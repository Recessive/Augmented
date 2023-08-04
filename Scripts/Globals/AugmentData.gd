extends Node

@export var headPackedAugments : Array[String]
@export var bodyPackedAugments : Array[String]
@export var armPackedAugments : Array[String]
@export var legPackedAugments : Array[String]


var headAugments : Array[Node]
var bodyAugments : Array[Node]
var armAugments : Array[Node]
var legAugments : Array[Node]

func _ready():
	for path in headPackedAugments:
		headAugments.append(load(path).instantiate())
	for path in bodyPackedAugments:
		bodyAugments.append(load(path).instantiate())
	for path in armPackedAugments:
		armAugments.append(load(path).instantiate())
	for path in legPackedAugments:
		legAugments.append(load(path).instantiate())
