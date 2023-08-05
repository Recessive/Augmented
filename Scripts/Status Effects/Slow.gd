extends "res://Scripts/Status Effects/StatusEffect.gd"



@onready
var originalSpeed : float = entity.SPEED

@export
var strength : float

func apply():
	active = true
	entity.SPEED /= strength
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
		entity.SPEED *= strength
		emit_signal("removed", self)
		queue_free()
