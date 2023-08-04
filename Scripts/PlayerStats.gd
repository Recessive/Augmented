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

var augments = {
	"head":"none",
	"body":"none",
	"leftarm":"none",
	"rightarm":"none",
	"leftleg":"none",
	"rightleg":"none"
}

var inventory = {
	"battery":3,
	"tube":2,
	"plate":1,
	"gear":0,
}

func _ready():
	hp = maxHP

static func delete_children(node):
	for n in node.get_children():
		node.remove_child(n)
		n.queue_free()
