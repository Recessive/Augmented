extends "res://Scripts/Augments/Augment.gd"

@export
var stackHealth : float

func add_stack():
	stacks += 1
	PlayerStats.maxHP += stackHealth
	PlayerStats.hp += stackHealth
	PlayerStats.update_healthbar()
