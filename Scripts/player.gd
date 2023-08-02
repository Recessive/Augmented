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
	
func hurt(attack : Attack):
	PlayerStats.hp -= attack.damage
	velocity = (global_position - attack.pos).normalized() * attack.knockback
	GlobalAssets.SpawnDamageNumber(attack.damage, global_position)

func beat(enabled : Array[bool], beat : int):
	if PlayerStats.locked:
		return
	if enabled[fireBeatIndex]:
		if Input.is_action_pressed("shoot"):
			shoot()
		elif !canClick:
			canClick = true
			# Play reload sound
