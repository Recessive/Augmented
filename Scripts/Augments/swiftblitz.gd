extends "res://Scripts/Augments/Augment.gd"


func add_stack():
	stacks += 1
	PlayerStats.attackSpeed -= 1
