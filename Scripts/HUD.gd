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
var switch_menu_func_enabled = false

func hide_menus():
	for menu in menus.values():
		menu.hide()

func switch_menu(menu):
	if not switch_menu_func_enabled:return
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
	PlayerStats.updated_inventory.connect(updated_inventory)
	PlayerStats.add_item(1, "gear")
	PlayerStats.add_item(1, "gear")
	PlayerStats.add_item(1, "tube")
	PlayerStats.add_item(2, "circuit")
	$HelperWindowRect.hide()
	
	menus = {
		'game':$Game,
		'pause':$PauseMenu,
		'options':$OptionsMenu,
		'upgrade':$UpgradeMenu
	}
	
	healthBar = $Game/TopInfo/Healthbar
	roomControl = $/root/main/RoomControl
	
	switch_menu_func_enabled = true
	switch_menu('game')
	
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

func updated_inventory():
	var t1 = PlayerStats.tier1Inventory
	var t2 = PlayerStats.tier2Inventory
	if t1.size() > 0:
		$Game/TopInfo/T1I1.visible = true
		$Game/TopInfo/T1I1.frame = AugmentData.dropFrameMapping.find(t1.keys()[0])
		$Game/TopInfo/T1I1/Label.text = "x%s" % t1[t1.keys()[0]]
	else:
		$Game/TopInfo/T1I1.visible = false
	
	if t1.size() > 1:
		$Game/TopInfo/T1I2.visible = true
		$Game/TopInfo/T1I2.frame = AugmentData.dropFrameMapping.find(t1.keys()[1])
		$Game/TopInfo/T1I2/Label.text = "x%s" % t1[t1.keys()[1]]
	else:
		$Game/TopInfo/T1I2.visible = false
	
	if t2.size() > 0:
		$Game/TopInfo/T2I1.visible = true
		$Game/TopInfo/T2I1.frame = AugmentData.dropFrameMapping.find(t2.keys()[0])
		$Game/TopInfo/T2I1/Label.text = "x%s" % t2[t2.keys()[0]]
	else:
		$Game/TopInfo/T2I1.visible = false
	

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


