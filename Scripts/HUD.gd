extends Control

var camera : Camera2D
var screen_size : Vector2
var healthBar : Node2D
var roomControl : Node
var menus : Dictionary
var activeMenu = 'game'

func hide_menus():
	for menu in menus.values():
		menu.hide()

func switch_menu(menu):
	hide_menus()
	menus[menu].show()
	activeMenu = menu

func update_camera():
	# places the gui on the camera
	camera = get_viewport().get_camera_2d()
	screen_size = get_viewport_rect().size
	size.x = screen_size.x / camera.zoom.x
	size.y = screen_size.y / camera.zoom.y
	global_position = camera.global_position - Vector2(size.x/2, size.y/2)
	# switch to the game window when you enter a new room
	switch_menu('game')

func _ready():
	menus = {
		'game':$Game,
		'pause':$PauseMenu,
		'options':$OptionsMenu
	}
	healthBar = $Game/TopInfo/Healthbar
	roomControl = $/root/main/RoomControl
	update_camera()

func _process(delta):
	# update the game menu
	if activeMenu == 'game':
		healthBar.updateHP(PlayerStats.hp/PlayerStats.maxHP)
		var depth = roomControl.depth
		var heat = roomControl.heat
		$Game/TopInfo/Label.text = "DEPTH: %s\nHEAT: %s" % [depth, heat]
		
		if Input.is_action_just_pressed('pause'):
			switch_menu('pause')
			get_tree().paused = true
			
	elif activeMenu == 'pause':
		if Input.is_action_just_pressed('pause'):
			switch_menu('game')
			get_tree().paused = false

func set_master_volume(volume : float):
	print('Volume set to ',volume)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), volume)

# When buttons pressed:
func _on_resume_pressed():
	switch_menu('game')
	get_tree().paused = false

func _on_back_pressed():
	switch_menu('pause')
	
func _on_options_pressed():
	switch_menu('options')
