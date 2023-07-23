extends Area2D

signal door_entered

func _on_body_entered(body):
	emit_signal("door_entered", self)
