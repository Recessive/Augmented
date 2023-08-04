extends Area2D

signal clicked

@export
var pair : Node

@export
var offset : Vector2

@export
var partName : String

@onready
var startingPos : Vector2 = position

@onready
var startingScale : Vector2 = scale

var pairActive : bool = false
func _process(delta):
	if mouseIn and Input.is_action_just_pressed("shoot"):
		emit_signal("clicked", self)
	if pair:
		if pair.mouseIn:
			pairActive = true
			modulate.g = 0
			modulate.b = 0
		elif pairActive and !mouseIn:
			pairActive = false
			modulate.g = 1
			modulate.b = 1
	

var mouseIn : bool = false
func _on_mouse_entered():
	if get_parent().selectable == true:
		mouseIn = true
		modulate.g = 0
		modulate.b = 0


func _on_mouse_exited():
	mouseIn = false
	modulate.g = 1
	modulate.b = 1


