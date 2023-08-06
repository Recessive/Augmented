extends Node

@export
var augmentName : String

@export
var augmentDesc : String

@export
var procChance : float = 1

@export
var chance : float  = 0

var stacks : int = 0

func add_stack():
	stacks += 1

func proc_hit(body : Node):
	pass

func proc_new_room():
	pass

func proc_death(body : Node):
	pass
