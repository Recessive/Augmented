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
	

func _process(delta):
	if pair and !pair.mouseIn:
		modulate.g = 1
		modulate.b = 1
		
	if !get_parent().selectable:
		modulate.g = 1
		modulate.b = 1
		return
	if mouseIn and Input.is_action_just_pressed("shoot"):
		emit_signal("clicked", self)
	if modulate.g != 0 and mouseIn :
		modulate.g = 0
		modulate.b = 0
	if pair and pair.mouseIn:
		modulate.g = 0
		modulate.b = 0
	
func reset_position():
	position = startingPos
	scale = startingScale

var mouseIn : bool = false
func _on_mouse_entered():
	mouseIn = true
	if get_parent().selectable:
		modulate.g = 0
		modulate.b = 0


func _on_mouse_exited():
	mouseIn = false
	modulate.g = 1
	modulate.b = 1


