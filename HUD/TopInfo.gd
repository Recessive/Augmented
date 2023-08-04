extends ColorRect

var goal_y : int = 0
var speed = 5.0

func _on_combat_start():
	goal_y = -size.y

func _on_combat_end():
	goal_y = 0

func _process(delta):
	position.y += speed * (goal_y - position.y) * delta
