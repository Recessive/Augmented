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
	"head":"basic",
	"body":"none",
	"leftarm":"basic",
	"rightarm":"none",
	"leftleg":"none",
	"rightleg":"basic"
}

var inventory = {
	"battery":0,
	"coil":0,
	"plate":0,
	"gear":0,
}

func _ready():
	hp = maxHP

static func delete_children(node):
	for n in node.get_children():
		node.remove_child(n)
		n.queue_free()
