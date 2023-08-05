extends "res://Scripts/Status Effects/StatusEffect.gd"


@export
var damage : float

@export
var frequency : int # in beats

@onready
var attack : Attack

func _ready():
	attack = Attack.new()
	attack.damage = damage
	attack.penetration = 0
	attack.knockback = 0
	attack.pos = Vector2()
	Conductor.onBeat.connect(beat)
	
func beat(enabled : Array[bool], beat : int):
	if beat % frequency == 0 and active:
		entity.hurt(attack)

func apply():
	active = true
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
		emit_signal("removed", self)
		queue_free()
