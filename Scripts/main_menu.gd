extends Node2D


@export
var mainScene : PackedScene

func _on_play_button_down():
	$Fade.visible = true
	var tween = create_tween().set_parallel()
	tween.tween_property($Fade, "modulate", Color(0,0,0,1), 1)
	tween.tween_property($AudioStreamPlayer, "volume_db", -80, 1)
	
	await tween.finished
	get_tree().change_scene_to_packed(mainScene)

