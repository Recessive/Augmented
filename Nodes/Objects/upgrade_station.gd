extends StaticBody2D

@export
var labelText : String
@onready
var label = $Label
@onready
var ui = $"/root/main/HUD"

var player : Node


func _ready():
	var key = str(InputMap.action_get_events("interact")[0].as_text().split(" ")[0])
	label.text = labelText % key
	print(ui)


var augmenting
func _process(delta):
	if Input.is_action_just_pressed("interact") and label.visible:
		GlobalAssets.atUpgradeStation = true
		player.visible = false
		PlayerStats.locked = true
		$AnimatedSprite2D.play("waiting")
		label.visible = false
		augmenting = true
		ui.augmentDisplay.expand()
		
	if Input.is_action_just_pressed("test") and augmenting:
		$AnimatedSprite2D.play("upgrade")
		await $AnimatedSprite2D.animation_finished
		$AnimatedSprite2D.play("default")

func _on_interact_area_entered(body):
	if body.is_in_group('Player'):
		player = body # Ah yes, how elegant
		label.visible = true
		


func _on_area_2d_body_exited(body):
	if body.is_in_group('Player'):
		label.visible = false
