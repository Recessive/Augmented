extends Control

var camera : Camera2D
var screen_size : Vector2

func update_camera():
	# places the gui on the camera
	camera = get_viewport().get_camera_2d()
	screen_size = get_viewport_rect().size
	size.x = screen_size.x / camera.zoom.x
	size.y = screen_size.y / camera.zoom.y
	global_position = camera.global_position
	print(global_position)

func _ready():
	update_camera()
