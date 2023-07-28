extends Node

@export
var SPEED : float

@export
var DAMAGE : float

@export
var fireBeats : int = 1


func _on_rigid_body_2d_body_entered(body):
	print("aaa")
	if !body.is_in_group("Enemy"):
		queue_free()
