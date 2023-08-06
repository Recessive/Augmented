extends Node2D

@export
var SPEED : float = 30
@export
var FRICTION : float = 15

@export
var highDamage : float

@export
var damageColor : Gradient

@export
var damageScale : Curve

var SHIFT_DIRECTION : Vector2 = Vector2.ZERO

@onready
var label = $Label

func _ready():
	SHIFT_DIRECTION = Vector2(randf_range(-1, 1), -1)

func _process(delta):
	global_position += SPEED * SHIFT_DIRECTION * delta
	SPEED = max(SPEED - FRICTION * delta, 0)
	if label.text.is_valid_float():
		var p = float(label.text) / highDamage
		
		label.modulate = damageColor.sample(p)
		var s = damageScale.sample(p) + 1
		scale = Vector2(s, s)
