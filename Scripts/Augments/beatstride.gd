extends "res://Scripts/Augments/Augment.gd"

@export
var speedUp : float

@export
var stackSpeed : float

func add_stack():
	stacks += 1
	if stacks != 1:
		PlayerStats.maxSpeed /= speedUp
	speedUp += stackSpeed
	PlayerStats.maxSpeed *= speedUp
