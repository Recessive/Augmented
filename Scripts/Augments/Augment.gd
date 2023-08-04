extends Node

@export
var augmentName : String

@export
var augmentDesc : String
 
# Should be format
# drop name : amount
@export
var cost : Dictionary

@export
var procChance : float = 1

var stacks : int = 1

func _ready():
	add_stack()

func add_stack():
	stacks += 1

func proc_hit(body : Node):
	pass

func proc_death(body : Node):
	pass
