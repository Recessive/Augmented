extends "res://Scripts/Augments/Augment.gd"

@export var speedMulti : float
@export var speedScaling : float

@onready
var timer : Timer = $Timer

func add_stack():
	stacks += 1
	speedMulti += speedScaling

var running = false
func proc_new_room():
	GlobalAssets._SpawnText("COME OUT SWINGING", PlayerStats.player.global_position, Color.PURPLE, Vector2(1, 1))
	if running:
		timer.start()
		return
	PlayerStats.maxSpeed *= speedMulti
	PlayerStats.attackSpeed -= 1
	running = true
	timer.start()
	await timer.timeout
	GlobalAssets._SpawnText("*huff puff*", PlayerStats.player.global_position, Color.GRAY, Vector2(1, 1))
	PlayerStats.maxSpeed /= speedMulti
	PlayerStats.attackSpeed += 1
	running = false
