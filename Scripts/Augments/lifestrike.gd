extends "res://Scripts/Augments/Augment.gd"

@export var chanceAdd : float

func add_stack():
	stacks += 1
	chance += chanceAdd

func proc_crit(body : Node):
	if randf() < chance:
		PlayerStats.heal(1)
