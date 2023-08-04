extends "res://Scripts/Augments/Augment.gd"

@export
var slowDebuff : PackedScene

func proc_hit(body : Node):
	if randf() < chance:
		body.apply_status(slowDebuff.instantiate())
