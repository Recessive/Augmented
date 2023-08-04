extends "res://Scripts/Status Effects/StatusEffect.gd"

@onready
var originalSpeed : float = entity.SPEED
	

func apply():
	active = true
	entity.SPEED /= 2
	timer.start()
	await timer.timeout
	remove()

func add_stack():
	timer.start()
	stacks += 1

func remove():
	if active:
		active = false
		timer.stop()
		entity.SPEED *= 2
