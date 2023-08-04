extends "res://Scripts/Augments/Augment.gd"

@export
var slowDebuff : PackedScene

func proc_hit(body : Node):
	body.apply_status(slowDebuff.instantiate())
