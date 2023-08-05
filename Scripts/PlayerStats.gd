extends Node

signal updated_inventory

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

func _ready():
	hp = maxHP

func can_add_item(tier : int, itemName : String):
	if tier == 1:
		if !tier1Inventory.has(itemName) and tier1Inventory.size() > 1:
			return false
	if tier == 2:
		if !tier2Inventory.has(itemName) and tier2Inventory.size() > 0:
			return false
	
	return true

func add_item(tier: int, itemName : String):
	if tier == 1:
		if tier1Inventory.has(itemName):
			tier1Inventory[itemName] += 1
		else:
			tier1Inventory[itemName] = 1
	if tier == 2:
		if tier2Inventory.has(itemName):
			tier2Inventory[itemName] += 1
		else:
			tier2Inventory[itemName] = 1
	emit_signal("updated_inventory")

func remove_item(tier : int, itemName : String, amount : int, sendUpdateSig : bool):
	if tier == 1:
		if tier1Inventory.has(itemName):
			tier1Inventory[itemName] -= amount
			if tier1Inventory[itemName] <= 0:
				if tier1Inventory[itemName] < 0:
					print("Less than zero items!")
				tier1Inventory.erase(itemName)
		else:
			print("Attempting to remove item not in inventory!")
			return
	if tier == 2:
		if tier2Inventory.has(itemName):
			tier2Inventory[itemName] -= amount
			if tier2Inventory[itemName] <= 0:
				if tier2Inventory[itemName] < 0:
					print("Less than zero items!")
				tier2Inventory.erase(itemName)
		else:
			print("Attempting to remove item not in inventory!")
			return
	
	if sendUpdateSig:
		emit_signal("updated_inventory")
	

func remove_recipe_items(recipe : Recipe):
	for i in recipe.tier1requirements:
		remove_item(1, i, recipe.tier1requirements[i], false)
	
	for i in recipe.tier2requirements:
		remove_item(2, i, recipe.tier2requirements[i], false)
	emit_signal("updated_inventory")

func augment_stacks(augment: Node):
	if augments.has(augment):
		return augments[augments.find(augment)].stacks
	else:
		return 0
	
func add_augment(augment : Node, bodyPart : String):
	if bodyPart == "Head":
		headAugments += 1
	if bodyPart == "Body":
		bodyAugments += 1
	if bodyPart == "Arms":
		armAugments += 1
	if bodyPart == "Legs":
		legAugments += 1
	
	augment.add_stack()
	
	if !augments.has(augment):
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
