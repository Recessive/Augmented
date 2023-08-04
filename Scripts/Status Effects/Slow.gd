extends "res://Scripts/Status Effects/StatusEffect.gd"



@onready
var originalSpeed : float = entity.SPEED

func apply():
	active = true
	entity.SPEED /= 2
	$Timer.start()
	await $Timer.timeout
	remove()

func add_stack():
	$Timer.start()
	stacks += 1

func remove():
	if active:
		stacks = 0
		active = false
		$Timer.stop()
		entity.SPEED *= 2
		emit_signal("removed", self)
		queue_free()
