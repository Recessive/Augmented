extends "res://Scripts/Base/EntityBase.gd"

@export
var disposables : Node

@export
var bullet : PackedScene

@export
var fireBeats : int = 1

@export
var fireBeatIndex : int

#Sticked those three together, as they are used in the same function
@export
var playerHealth : float = 10.0
@onready 
var invi : Node = $Invincibility
@onready
var canTakeDmg : bool = invi.is_stopped()
@onready 
var healthSprite : Node = get_node("../Healthbar/HealthbarSprite")

@onready
var weaponShootSound : AudioStreamPlayer = $WeaponShoot

var AugmentRenderer

func _ready():
	AugmentRenderer = $PlayerAugmentRenderer
	Conductor.onBeat.connect(beat)


var canClick = true
var aniPlaying : bool = false
var playingUp : bool = false

func _physics_process(delta):
	if PlayerStats.locked:
		return
	var direc = Vector2(0, 0)
	var lr = Input.get_axis("move_left", "move_right")
	var ud = Input.get_axis("move_up", "move_down")
	
	if lr == -1:
		$Sprite2D.flip_h = true
		AugmentRenderer.flip_h(true)
	elif lr == 1:
		$Sprite2D.flip_h = false
		AugmentRenderer.flip_h(false)
	
	aniPlaying = false
	playingUp = false
		
	if lr:
		$AnimationPlayer.play("side")
		AugmentRenderer.start_all("side")
		aniPlaying = true
	
	if ud and not aniPlaying:
		aniPlaying = true
		if ud > 0:
			$AnimationPlayer.play("down")
			AugmentRenderer.start_all("down")
		else:
			$AnimationPlayer.play("up")
			AugmentRenderer.start_all("up")
			playingUp = true
	
	direc.x += lr
	direc.y += ud
	
	
	if !lr and !ud and !aniPlaying:
		$AnimationPlayer.stop()
		AugmentRenderer.stop_all()
	
	direc = direc.normalized()
	
	velocity = velocity.move_toward(direc * PlayerStats.maxSpeed, PlayerStats.acceleration * delta)
	move_and_slide()
	
	if Input.is_action_just_pressed("shoot") and canClick:
		# Immediately shoot to give responsiveness, then start shooting on the beat
		shoot()
		canClick = false

func shoot():
	var b : Node = bullet.instantiate()
	var vel = global_position.direction_to(get_global_mouse_position()).normalized() * b.SPEED
	disposables.add_child(b)
	b.isCrit = randf() < PlayerStats.critChance
	b.global_position = global_position
	b.velocity = vel
	weaponShootSound.play()
	if !playingUp:
		$ShootAnimator.play("shoot")

####################
#MAIN CHANGES HERE #
####################

func hurt(attack : Attack):
	if canTakeDmg == true:
		PlayerStats.hp -= attack.damage
		velocity = (global_position - attack.pos).normalized() * attack.knockback
		GlobalAssets.SpawnDamageNumber(attack.damage, global_position)
		healthSprite.play("DmgTaken")
		await healthSprite.is_playing() == false
		if PlayerStats.hp >= 66 and healthSprite.is_playing() == false:
			healthSprite.play("Normal")
		elif PlayerStats.hp < 66 and PlayerStats.hp >= 33 and healthSprite.is_playing() == false:
			healthSprite.play("Cracked")
		elif PlayerStats.hp < 33 and healthSprite.is_playing() == false:
			healthSprite.play("VeryCracked")

func beat(enabled : Array[bool], beat : int):
	if PlayerStats.locked:
		return
	if enabled[fireBeatIndex]:
		if Input.is_action_pressed("shoot"):
			shoot()
		elif !canClick:
			canClick = true
			# Play reload sound



