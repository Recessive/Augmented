extends "res://Scripts/Augments/Augment.gd"

@export
var burnDebuff : PackedScene

@export
var chanceAdd : float

func proc_hit(body : Node):
	if randf() < chance:
		body.apply_status(burnDebuff.instantiate())

func add_stack():
	stacks += 1
	if stacks > 1:
		chance += chanceAdd
