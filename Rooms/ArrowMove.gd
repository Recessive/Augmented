extends Sprite2D

var time : float = 0

@onready
var startY : float = position.y

func _process(delta):
	time += delta
	position.y = startY + sin(time * TAU) * 4
