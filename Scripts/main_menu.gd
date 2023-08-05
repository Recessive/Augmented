extends Node2D


@export
var mainScene : PackedScene

func _on_play_button_down():
	get_tree().change_scene_to_packed(mainScene)
