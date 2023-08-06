extends "res://Scripts/Augments/Augment.gd"

@export var baseHeal : float

func proc_new_room():
	PlayerStats.heal(baseHeal * stacks)
