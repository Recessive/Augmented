extends Control

var camera : Camera2D
var screen_size : Vector2
var healthBar : Node2D
var roomControl : Node

func update_camera():
	# places the gui on the camera
	camera = get_viewport().get_camera_2d()
	screen_size = get_viewport_rect().size
	size.x = screen_size.x / camera.zoom.x
	size.y = screen_size.y / camera.zoom.y
	global_position = camera.global_position - Vector2(size.x/2, size.y/2)
	print(global_position)

func _ready():
	healthBar = $Game/TopInfo/Healthbar
	roomControl = $/root/main/RoomControl
	update_camera()

func _process(delta):
	healthBar.updateHP(PlayerStats.hp/PlayerStats.maxHP)
	var depth = roomControl.depth
	var heat = roomControl.heat
	$Game/TopInfo/Label.text = "DEPTH: %s\nHEAT: %s" % [depth, heat]
