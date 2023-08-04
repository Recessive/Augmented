extends Control

var camera : Camera2D
var screen_size : Vector2
var healthBar : Node2D
var roomControl : Node
var menus : Dictionary
var activeMenu = 'game' 

@onready var augmentDisplay = $"Game/TopInfo/Augment Menu"

const PLURAL_ITEM : Dictionary = {
	"gear":"gears",
	"plate":"plates",
	"battery":"batteries",
	"tube":"tubes"
}

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
	$HelperWindowRect.hide()
	
	menus = {
		'game':$Game,
		'pause':$PauseMenu,
		'options':$OptionsMenu,
		'upgrade':$UpgradeMenu
	}
	
	healthBar = $Game/TopInfo/Healthbar
	roomControl = $/root/main/RoomControl
	
	update_camera()

func check_for_enemies():
	var currentRoom = roomControl.get_children()[-1]
	for child in currentRoom.get_children():
		if child.is_in_group("Enemies"):
			return true
	return false

var wasEnemyActive = true
var isEnemyActive = false

func _process(delta):
	
	isEnemyActive = check_for_enemies()
	if wasEnemyActive!=isEnemyActive:
		if isEnemyActive: $Game/TopInfo._on_combat_start()
		else: $Game/TopInfo._on_combat_end()
	wasEnemyActive = isEnemyActive
	
	# update the game menu
	if activeMenu == 'game':
		var depth = roomControl.depth
		$Game/TopInfo/Label.text = "DEPTH: %s" % depth

	if Input.is_action_just_pressed('pause'):
		if activeMenu == 'pause':
			switch_menu('game')
			get_tree().paused = false
		else:
			switch_menu('pause')
			get_tree().paused = true

func set_master_volume(volume : float):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), volume)

# When buttons pressed:
func _on_resume_pressed():
	switch_menu('game')
	get_tree().paused = false

func _on_back_pressed():
	switch_menu('pause')
	
func _on_options_pressed():
	switch_menu('options')


