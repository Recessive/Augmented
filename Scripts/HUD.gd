extends Control

var camera : Camera2D
var screen_size : Vector2
var healthBar : Node2D
var roomControl : Node
var menus : Dictionary
var activeMenu = 'game'

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
		healthBar.updateHP(PlayerStats.hp/PlayerStats.maxHP)
		var depth = roomControl.depth
		var heat = roomControl.heat
		var inventory : Dictionary = PlayerStats.inventory
		var inventoryString : String = ""
		for item in inventory:
			inventoryString += ('\n%s: %s' % [item, inventory[item]]).to_upper()
		$Game/TopInfo/Label.text = "DEPTH: %s\nHEAT: %s%s" % [depth, heat, inventoryString]

	if Input.is_action_just_pressed('pause'):
		if activeMenu == 'pause':
			switch_menu('game')
			get_tree().paused = false
		else:
			switch_menu('pause')
			get_tree().paused = true

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


func _on_upgrade_shortcut_pressed():
	switch_menu('upgrade')

var partName : String
var upgradeName : String
var playerCanAfford = false

func _on_part_label_value_updated(stringValue):
	partName = stringValue

func _on_upgrade_label_value_updated(stringValue):
	upgradeName = stringValue
	update_upgrade_cost()

func update_upgrade_cost():
	var label : Label = $UpgradeMenu/Buttons/CostLabel
	var cost : Dictionary = AugmentData.AUGMENTS[upgradeName]['cost']
	print(upgradeName,": ",cost)
	var itemStrings : Array[String] = []
	playerCanAfford = true
	for item in cost:
		var ammount : int = cost[item]
		
		if PlayerStats.inventory[item] < ammount: playerCanAfford = false
		
		if ammount == 0: continue
		item = item if ammount == 1 else PLURAL_ITEM[item]
		itemStrings.append("%s %s" % [ammount, item])
	if playerCanAfford:
		$UpgradeMenu/Buttons/UpgradeButton.disabled = false
		label.modulate = Color(0, 1, 0)
	else:
		$UpgradeMenu/Buttons/UpgradeButton.disabled = true
		label.modulate = Color(1, 0, 0)
	label.text = "Cost: " + ", ".join(itemStrings)


func _on_upgrade_button_pressed():
	var cost : Dictionary = AugmentData.AUGMENTS[upgradeName]['cost']
	for item in cost:
		PlayerStats.inventory[item] -= cost[item]
	
	print('upgraded player\'s ',partName,' with ',upgradeName)
	
	partName = partName.to_lower().replace(' ','')
	
	PlayerStats.augments[partName] = upgradeName
	
	$/root/main/Player/PlayerAugmentRenderer.update()
	update_upgrade_cost()

