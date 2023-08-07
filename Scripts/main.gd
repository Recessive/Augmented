extends Node

@export
var mainMenuScenePath : String

func _ready():
	PlayerStats.start()
	PlayerStats.locked = false
	$Fade.modulate.a = 1
	var tween = create_tween().set_parallel()
	tween.tween_property($Fade, "modulate", Color(1,1,1,0), 1)
	tween.tween_property($BasicComponents, "volume_db", -20, 1)
	await tween.finished
	
	# buff_player()
	
func buff_player():
	for i in range(1):
		PlayerStats.add_augment(AugmentData.name_to_augment("Overclock"), "Head")
	for i in range(2):
		PlayerStats.add_augment(AugmentData.name_to_augment("Swiftblitz"), "Head")
	for i in range(5):
		PlayerStats.add_augment(AugmentData.name_to_augment("Synthflare"), "Arms")
	for i in range(3):
		PlayerStats.add_augment(AugmentData.name_to_augment("Beatstride"), "Body")
	
	

func dead():
	$"GameOver/MarginContainer/VBoxContainer/VBoxContainer2/Death Message".text = $GameOver.messages.pick_random()
	$"GameOver/MarginContainer/VBoxContainer/VBoxContainer3/Depth Message".text = "You made it to a depth of %s" % PlayerStats.depth
	PlayerStats.locked = true
	PlayerStats.proc_player_death()
	var tween = create_tween().set_parallel()
	$GameOver.visible = true
	tween.tween_property($"BasicComponents", "volume_db", -80, 2)
	tween.tween_property($HUD.get_node("Game"), "modulate", Color(0, 0, 0, 0), 2)
	tween.tween_property($GameOver, "modulate", Color(1, 1, 1, 1), 2)
	
# Continue back to main menu
func _on_button_button_down():
	$SceneFade.visible = true
	var tween = create_tween()
	tween.tween_property($SceneFade, "modulate", Color(1,1,1,1), 2)
	
	await tween.finished
	PlayerStats.start()
	get_tree().change_scene_to_file(mainMenuScenePath)
