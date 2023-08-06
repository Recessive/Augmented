extends Node

@export var headPackedAugments : Array[String]
@export var bodyPackedAugments : Array[String]
@export var armPackedAugments : Array[String]
@export var legPackedAugments : Array[String]

@export var recipes : Array[Recipe]

@export var dropsPacked : Dictionary

@export var dropFrameMapping : Array[String]


var headAugments : Array[Node]
var bodyAugments : Array[Node]
var armsAugments : Array[Node]
var legsAugments : Array[Node]

func _ready():
	for path in headPackedAugments:
		var node = load(path).instantiate()
		headAugments.append(node)
		add_child(node)
	for path in bodyPackedAugments:
		var node = load(path).instantiate()
		bodyAugments.append(node)
		add_child(node)
	for path in armPackedAugments:
		var node = load(path).instantiate()
		armsAugments.append(node)
		add_child(node)
	for path in legPackedAugments:
		var node = load(path).instantiate()
		legsAugments.append(node)
		add_child(node)
	
	recipes.sort_custom(sort_recipes)

func name_to_augment(name : String) -> Node:
	for aug in headAugments:
		if aug.augmentName == name:
			return aug
	for aug in bodyAugments:
		if aug.augmentName == name:
			return aug
	for aug in armsAugments:
		if aug.augmentName == name:
			return aug
	for aug in legsAugments:
		if aug.augmentName == name:
			return aug
	print("Couldn't find augment: " + name)
	return null
	
func sort_recipes(a, b) -> bool:
	return a.quality > b.quality

