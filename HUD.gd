extends Node

@export
var hpLabel : Label

func _process(delta):
	hpLabel.text = "HP: " + str(PlayerStats.hp)
