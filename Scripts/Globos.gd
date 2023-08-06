extends "res://Scripts/Base/EnemyBase.gd"

@export
var DAMAGE : float

@export
var PENETRATION : float

@export
var KNOCKBACK : float

@export
var chargeBeats : int

@export
var chargeFrequency : int

@export
var offsetBeats : int

@export
var minShootDist : float

@export
var laserChargeWidth : float

@export
var laserFireWidth : float

@export
var laserFireDuration : float

@export
var laserParticleDuration : float

@export
var laserChargeCurve : Curve

@export
var laserScene : String

@onready
var player : Node = $"/root/main/Player" # TODO: Change this to work with a spawner

@onready
var telegraphLine : Line2D = $TelegraphLine

@onready
var laserChargeLine : Line2D = $LaserCharge

@onready
var laserLockSound : AudioStreamPlayer = $LaserLockSound

@onready
var laserSound : AudioStreamPlayer = $LaserSound



@onready
var space = get_world_2d().direct_space_state

var charging = false
var angle = randf_range(0, 2 * PI)
var direc = Vector2(cos(angle), sin(angle))

@onready
var target : Vector2 = global_position
@onready
var pivot : Vector2 = global_position

var animation : AnimatedSprite2D

# Kind of yuck, but have to move the sprite and area2d instead of the parent, because if
# I moved the parent the telegraph lines would move too

var laserTween : Tween
func _ready():
	_parent_ready()
	Conductor.onBeat.connect(beat)
	telegraphLine.add_point(Vector2(0, 0))
	laserChargeLine.add_point(Vector2(0, 0))
	laserChargeLine.add_point(Vector2(0, 0))
	
	animation = $DeathAnimation
	
	lastShootBeat = Conductor.beatNumber
	
	
	

func reset_laserCharge():
	laserChargeLine.set_point_position(0, Vector2(0, 0))
	laserChargeLine.set_point_position(1, Vector2(0, 0))
	
func fire_laser(start : Vector2, end : Vector2):
	var laserLine = load(laserScene).instantiate()
	add_child(laserLine)
	laserLine.add_point(laserLine.to_local(start))
	laserLine.add_point(laserLine.to_local(end))
	laserLine.width = laserFireWidth
	var laserTween = get_tree().create_tween()
	laserTween.tween_property(laserLine, "width", 0, laserFireDuration)
	laserTween.tween_interval(laserParticleDuration)
	laserTween.tween_callback(laserLine.queue_free)
@onready
var chargeAniLength : float = $AnimationPlayer.get_animation("charge").length
func _physics_process(delta):
	animation.global_position = $Sprite2D.global_position
	if dead: return
	var p : float
	if preppingBeats > 0:
		p = Conductor.percentage_beat(lastShootBeat, lastShootBeat + chargeBeats * chargeFrequency)
	else:
		
		p = Conductor.percentage_beat(lastShootBeat, lastShootBeat + chargeFrequency)
	# Take next enabled beat on responseBeat index and gradually increase laser size
	# If there exists more than 2 points in the telegraphLine that is
	if telegraphLine.points.size() > 1:
		var p1 = laserChargeLine.to_local(telegraphLine.to_global(telegraphLine.points[0]))
		var p2 = laserChargeLine.to_local(telegraphLine.to_global(telegraphLine.points[1]))
		laserChargeLine.set_point_position(0, p1)
		laserChargeLine.set_point_position(1, p2)
		laserChargeLine.width = laserChargeWidth * laserChargeCurve.sample(p)
	
	if preppingBeats == 0:
		$AnimationPlayer.seek(p * chargeAniLength)
	
func _on_player_hurt_body_entered(body : Node):
	if body.is_in_group("Player"):
		damage_player(sprite.global_position, body)

func hurt(attack : Attack):
	if dead:
		return
	hp -= attack.damage
	GlobalAssets.SpawnDamageNumber(attack.damage, sprite.global_position)
	
func die():
	dead = true
	disable_collision()
	
	$Sprite2D.visible = false
	$TelegraphLine.visible = false
	$LaserCharge.visible = false
	global_position = $Sprite2D.global_position
	$Sprite2D.position = Vector2()
	$DeathAnimation.visible = true
	drop()
	animation.play("death")
	await $DeathAnimation.animation_finished
	
	emit_signal("died", self)
	queue_free()

func damage_player(pos : Vector2, body : Node):
	var attack = Attack.new()
	attack.damage = DAMAGE
	attack.penetration = PENETRATION
	attack.knockback = KNOCKBACK
	attack.pos = pos
	body.hurt(attack)

@onready 
var preppingBeats : int = chargeBeats
var lastShootBeat : int
var result
func beat(enabled : Array[bool], beat : int):
	if dead: return
	if beat % chargeFrequency != 0:
		return
	
	if preppingBeats > 0:
		preppingBeats -= 1
		laserLockSound.play()
		pivot = target
		var pos
		if(telegraphLine.points.size() == 1):
			pos = sprite.global_position
		else:
			pos = telegraphLine.to_global(telegraphLine.points[-1])
			
		# Magic value:
		# 10,000: make raycast long
		# 0x00000001: Only collide with wall layer
		var query = PhysicsRayQueryParameters2D.create(pos, direc*10000, 0x00000001)
		result = space.intersect_ray(query)
		
		if result.is_empty():
			print("Globos didn't find valid path!")
			telegraphLine.add_point(telegraphLine.to_local(pos))
		else:
			telegraphLine.add_point(telegraphLine.to_local(result.position - direc.normalized()*(minShootDist/8)))
			direc = direc.bounce(result.normal)
		if preppingBeats == 0:
			lastShootBeat = beat
			$AnimationPlayer.play("charge")
	else:
		lastShootBeat = beat
		# "Shoot" along the drawn path
		laserSound.play()
		pivot = telegraphLine.to_global(telegraphLine.points[0])
		target = telegraphLine.to_global(telegraphLine.points[1])
		
		area2d.global_position = target
		sprite.global_position = target
		fire_laser(pivot, target)
		
		# First, check if the player is along the path to do damage:
		# Player is on layer 10 (base 2)
		var query = PhysicsRayQueryParameters2D.create(pivot, target, 2)
		result = space.intersect_ray(query)
		if result:
			damage_player(pivot, result.collider)
		
		telegraphLine.remove_point(0)
		reset_laserCharge()
		if telegraphLine.points.size() == 1:
			angle = sprite.global_position.angle_to_point(player.global_position)
			direc = Vector2(cos(angle), sin(angle))
			$AnimationPlayer.play("idle")
			preppingBeats = chargeBeats
