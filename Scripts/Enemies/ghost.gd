extends "res://Scripts/Base/EnemyBase.gd"

# Move towards player every first beat, pause every second

@export
var beatIndex : int = 2

@onready
var player : Node = $"/root/main/Player"

var direc : Vector2 = Vector2()

func _ready():
	$"Sprite2D/Healthbar".maxHP = maxHP
	Conductor.onBeat.connect(beat)
	add_to_group('Enemies')
	
func _physics_process(delta):
	if dead: return
	global_position.angle_to_point(player.global_position)
	velocity = velocity.move_toward(direc * SPEED, ACCELERATION * delta)
	move_and_slide()
	
func beat(enabled : Array[bool], beat : int):
	if dead: return
	# Move towards the player on beat
	# Pause every second beat
	if enabled[2]:
		if direc == Vector2():
			direc = global_position.direction_to(player.global_position)
		else:
			direc = Vector2()
