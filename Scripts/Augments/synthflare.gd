extends "res://Scripts/Augments/Augment.gd"

@export
var burnDebuff : PackedScene

func proc_hit(body : Node):
	if randf() < chance:
		body.apply_status(burnDebuff.instantiate())

func add_stack():
	stacks += 1
	chance += 0.1
