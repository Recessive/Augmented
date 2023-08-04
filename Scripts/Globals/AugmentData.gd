extends Node

@export var headPackedAugments : Array[String]
@export var bodyPackedAugments : Array[String]
@export var armPackedAugments : Array[String]
@export var legPackedAugments : Array[String]

@export var recipes : Array[Recipe]


var headAugments : Array[Node]
var bodyAugments : Array[Node]
var armsAugments : Array[Node]
var legsAugments : Array[Node]

func _ready():
	for path in headPackedAugments:
		headAugments.append(load(path).instantiate())
	for path in bodyPackedAugments:
		bodyAugments.append(load(path).instantiate())
	for path in armPackedAugments:
		armsAugments.append(load(path).instantiate())
	for path in legPackedAugments:
		legsAugments.append(load(path).instantiate())

func name_to_augment(name : String):
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
