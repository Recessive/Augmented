extends "res://Scripts/Base/EntityBase.gd"

@export
var disposables : Node

@export
var bullet : PackedScene

@export
var fireBeats : int = 1

@export
var fireBeatIndex : int

@onready
var weaponChargeSound : AudioStreamPlayer = $WeaponCharge

@onready
var weaponShootSound : AudioStreamPlayer = $WeaponShoot



func _ready():
	Conductor.onBeat.connect(beat)


var canClick = true
func _physics_process(delta):
	if PlayerStats.locked:
		return
	var direc = Vector2(0, 0)
	var lr = Input.get_axis("move_left", "move_right")
	var ud = Input.get_axis("move_up", "move_down")
	if lr:
		direc.x += lr
	if ud:
		direc.y += ud
		
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
	b.global_position = global_position
	b.velocity = vel
	weaponShootSound.play()
	
func hurt(attack : Attack):
	PlayerStats.hp -= attack.damage
	velocity = (global_position - attack.pos).normalized() * attack.knockback
	GlobalAssets.SpawnDamageNumber(attack.damage, global_position)
	pass

func beat(enabled : Array[bool], beat : int):
	if enabled[fireBeatIndex]:
		if Input.is_action_pressed("shoot"):
			shoot()
		elif !canClick:
			canClick = true
			# Play reload sound
