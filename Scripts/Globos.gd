extends Node2D

@export
var DAMAGE : float

@export
var PENETRATION : float

@export
var KNOCKBACK : float

@export
var moveCurve : Curve

@export
var callBeat : int

@export
var responseBeat : int

@export
var offsetBeats : int

@export
var minShootDist : float

@onready
var sprite : Sprite2D = $Sprite2D

@onready
var line : Line2D = $Line2D

@onready
var space = get_world_2d().direct_space_state

var charging = false
var angle = randf_range(0, 2 * PI)
var direc = Vector2(cos(angle), sin(angle))

@onready
var target : Vector2 = global_position
@onready
var pivot : Vector2 = global_position

func _ready():
	Conductor.onBeat.connect(beat)
	line.add_point(Vector2(0, 0))


func _physics_process(delta):
	
	# Fire a ray that bounces 4 times
	# Then shoot itself along the ray 4 times stopping after the 4th bounce
	
	# I think this would be better with call and response
	
	# TO THE BEAT
	# character.global_position = pivot + (target - pivot) * moveCurve.sample(Conductor.percentage_enabled(beatIndex))
	sprite.global_position = target
	# line.set_point_position(0, character.position)

	# var col = move_and_collide(direc * SPEED * delta)
	# if col:
	# 	direc = direc.bounce(col.get_normal())
	pass


func damage_player(pos : Vector2, body : Node):
	var attack = Attack.new()
	attack.damage = DAMAGE
	attack.penetration = PENETRATION
	attack.knockback = KNOCKBACK
	attack.pos = pos
	body.hurt(attack)

func _on_player_hurt_body_entered(body : Node):
	if body.is_in_group("Player"):
		var attack = Attack.new()
		attack.damage = DAMAGE
		attack.penetration = PENETRATION
		attack.knockback = KNOCKBACK
		attack.pos = global_position
		body.hurt(attack)

var prepping : bool = true
var result
func beat(enabled : Array[bool], beat : int):
	if(enabled[callBeat]):
		if offsetBeats > 0:
			offsetBeats -= 1
			return
		
		pivot = target
		var pos
		if(line.points.size() == 1):
			pos = sprite.global_position
		else:
			pos = line.to_global(line.points[-1])
		
		# Magic value:
		# 10,000: make raycast long
		# 0x00000001: Only collide with wall layer
		var query = PhysicsRayQueryParameters2D.create(pos, direc*10000, 0x00000001)
		result = space.intersect_ray(query)
		
		if result.is_empty():
			print("broke")
			line.add_point(line.to_local(pos))
		else:
			line.add_point(line.to_local(result.position - direc.normalized()*(minShootDist/8)))
			direc = direc.bounce(result.normal)
		
	if(enabled[responseBeat]):
		# "Shoot" along the drawn path
		if line.points.size() == 1:
			return
			
		pivot = line.to_global(line.points[0])
		target = line.to_global(line.points[1])
		
		# First, check if the player is along the path to do damage:
		# Player is on layer 10 (base 2)
		var query = PhysicsRayQueryParameters2D.create(pivot, target, 2)
		result = space.intersect_ray(query)
		if result:
			damage_player(pivot, result.collider)
		
		line.remove_point(0)
		if line.points.size() == 1:
			angle = randf_range(0, 2*PI)
			for addAng in [0, PI/2, PI, 3*PI/2]:
				direc = Vector2(cos(angle+addAng), sin(angle+addAng))
				query = PhysicsRayQueryParameters2D.create(target, direc*10000, 0x00000001)
				result = space.intersect_ray(query)
				if result.is_empty():
					continue
				var d = target.distance_to(result.position)
				if d > minShootDist:
					angle += addAng
					break
			direc = Vector2(cos(angle), sin(angle))
			prepping = true
