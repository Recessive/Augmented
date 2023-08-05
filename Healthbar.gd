extends Node2D


var maxHP : float : set = set_maxHP

func set_maxHP(value):
	$Value/Label.text = str(value)
	maxHP = value

func updateHP(hp : float):
	$Fore.scale.x = hp / maxHP
	$Value/Label.text = str(hp)
