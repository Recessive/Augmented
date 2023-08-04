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

var headAugments : int = 0
var bodyAugments : int = 0
var armAugments : int = 0
var legAugments : int = 0

var augments : Array[Node] # All body part augments combined

@onready
var player : Node = $"/root/main/Player"

# Only 2 slots in tier 1
# Tier 1 components:
# battery
# tube
# plate
# gear
var tier1Inventory : Dictionary = {}

# Only 1 slot in tier 2
# Tier 2 components:
# Circuit
# Tranceiver
var tier2Inventory : Dictionary = {}

var inventory : Dictionary = {
	"battery":3,
	"tube":2,
	"plate":1,
	"gear":0,
}

func _ready():
	hp = maxHP
	
func add_augment(augment : Node, bodyPart : String):
	if bodyPart == "Head":
		headAugments += 1
	if bodyPart == "Body":
		bodyAugments += 1
	if bodyPart == "Arms":
		armAugments += 1
	if bodyPart == "Legs":
		legAugments += 1
	
	if augments.has(augment):
		augments[augments.find(augment)].add_stack()
	else:
		augments.append(augment)

func proc_hit(body : Node):
	for aug in augments:
		aug.proc_hit(body)

func proc_death(body : Node):
	for aug in augments:
		aug.proc_death(body)


static func delete_children(node):
	for n in node.get_children():
		node.remove_child(n)
		n.queue_free()
