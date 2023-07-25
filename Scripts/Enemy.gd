extends Node
@export
var health : float

@export
var armor : float

func damage(value : float):
	health -= value
	if health <= 0:
		die()

func die():
	pass


