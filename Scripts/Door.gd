extends StaticBody2D

signal door_entered

func _on_enter_door_body_entered(body):
	if body.is_in_group("Player"):
		emit_signal("door_entered", self)
