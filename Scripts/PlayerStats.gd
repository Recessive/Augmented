extends Node

@export
var maxHP : float

@export
var maxArmor : float

@export
var maxSpeed : float

@export
var acceleration : float

@export
var critChance : float

var locked : bool = false

var hp : float

func _ready():
	hp = maxHP

static func delete_children(node):
	for n in node.get_children():
		node.remove_child(n)
		n.queue_free()
