extends ColorRect

var goal_y : int = 0
var speed = 1/20

func _on_combat_start():
	goal_y = -size.y

func _on_combat_end():
	goal_y = 0

func _ready():
	# still need to implement a system to detect if there are any enemies
	GlobalAssets.connect("combatEnd", _on_combat_end)
	GlobalAssets.connect("combatStart", _on_combat_start)

func _process(delta):
	position.y += speed * (goal_y - position.y)
