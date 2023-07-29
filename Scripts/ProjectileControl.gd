extends CharacterBody2D

@export
var SPEED : float

@export
var DAMAGE : float

@export
var fireBeats : int = 1

var ignoreCol = true

func _physics_process(delta):
	move_and_collide(velocity)


func _on_area_2d_body_entered(body):
	if ignoreCol:
		return
	if !body.is_in_group("Enemy"):
		queue_free()
