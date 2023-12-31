extends Node

signal updated_inventory


@export
var startMaxHP : float

@export
var startMaxArmor : float

@export
var startMaxSpeed : float

@export
var startAcceleration : float

@export
var startDamage : float

@export
var startCritChance : float

@export
var startAttackSpeed : int # In beats

@export
var heatScaling : float

@export
var highHeat : int

var maxHP : float
var maxArmor : float
var maxSpeed : float
var acceleration : float
var damage : float
var critChance : float
var attackSpeed : int : set = set_attack_speed
var knockbackResistance : float

var locked : bool = false

var hp : float : set = set_hp

var headAugments : int = 0
var bodyAugments : int = 0
var armAugments : int = 0
var legAugments : int = 0

var augments : Array[Node] # All body part augments combined

var depth : int = 0
var heat : int = 0


var player : Node
var disposables : Node


# Only 2 slots in tier 1
# Tier 1 components:
# battery
# tube
# plate
# gear
var tier1Inventory

# Only 1 slot in tier 2
# Tier 2 components:
# Circuit
# Tranceiver
var tier2Inventory

func start():
	tier1Inventory = {}
	tier2Inventory = {}
	
	maxHP = startMaxHP 
	maxArmor = startMaxArmor 
	maxSpeed = startMaxSpeed 
	acceleration = startAcceleration 
	damage = startDamage
	critChance = startCritChance
	attackSpeed = startAttackSpeed
	knockbackResistance = 1
	hp = maxHP
	
	depth = 0
	heat = 0
	
	headAugments = 0
	bodyAugments = 0
	armAugments = 0
	legAugments = 0
	
	for aug in augments:
		aug.reset_stacks()
	augments = []
	
	player = $"/root/main/Player"
	disposables = $"/root/main/Disposables"

func get_heat_scale() -> float:
	return 1 + heat * heatScaling

func heal(value):
	hp = min(hp + value, maxHP)
	GlobalAssets._SpawnText("+" + str(value) + " ", player.global_position, Color.GREEN, Vector2(1, 1))
	
func set_hp(value):
	hp = value
	update_healthbar()

func set_attack_speed(value):
	attackSpeed = max(1, value)

func update_healthbar():
	$"/root/main/HUD/Game/TopInfo/Healthbar".maxHP = maxHP
	$"/root/main/HUD/Game/TopInfo/Healthbar".updateHP(hp)

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

func proc_crit(body : Node):
	for aug in augments:
		aug.proc_crit(body)

func proc_death(body : Node):
	for aug in augments:
		aug.proc_death(body)

func proc_new_room():
	for aug in augments:
		aug.proc_new_room()

func proc_player_death():
	pass


static func delete_children(node):
	for n in node.get_children():
		node.remove_child(n)
		n.queue_free()
