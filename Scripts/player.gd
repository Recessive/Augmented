extends CharacterBody2D

@export
var bullet : PackedScene

@export
var fireBeats : int = 1

@export
var fireBeatIndex : int

func _ready():
	Conductor.onBeat.connect(beat)


var charging : bool = false
var chargingBullet : CharacterBody2D
func _physics_process(delta):
	
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
	
	if Input.is_action_pressed("shoot") and !charging:
		
		# Initially, set bullet position to right on top of player
		var b : Node = bullet.instantiate()
		add_child(b)
		
		charging = true
		chargingBullet = b
	
	if charging:
		var chargeAni : AnimatedSprite2D = chargingBullet.get_node("ChargeAni")
		var p : float = Conductor.percentage_enabled(fireBeatIndex)
		chargeAni.frame = floor(chargeAni.sprite_frames.get_frame_count("default") * p)

func hurt(attack : Attack):
	PlayerStats.hp -= attack.damage
	velocity = (global_position - attack.pos).normalized() * attack.knockback
	pass

func beat(enabled : Array[bool], beat : int):
	if enabled[fireBeatIndex] and charging:
		charging = false
		chargingBullet.ignoreCol = false
		chargingBullet.get_node("ChargeAni").visible = false
		chargingBullet.get_node("BulletAni").visible = true
		var vel = global_position.direction_to(get_global_mouse_position()).normalized() * chargingBullet.SPEED
		chargingBullet.velocity = vel
		remove_child(chargingBullet)
		get_tree().get_root().add_child(chargingBullet)
		chargingBullet.global_position = global_position
		
		
