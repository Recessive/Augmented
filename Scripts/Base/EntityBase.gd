extends CharacterBody2D

signal died

@export
var maxHP : float

@onready
var hp = maxHP : set = set_hp

var statusEffects : Dictionary

@onready var sprite : Sprite2D = $Sprite2D
@onready var collShape : CollisionShape2D = $CollisionShape2D
@onready var animPlayer : AnimationPlayer = $AnimationPlayer
@onready var area2d : Area2D = $Area2D

@onready var tColLayers : int = collision_layer
@onready var tAreaColLayers : int = $Area2D.collision_layer

@onready var tColMask : int = collision_mask
@onready var tAreaColMask : int = $Area2D.collision_mask

func disable_collision():
	tColLayers = collision_layer
	tAreaColLayers = $Area2D.collision_layer
	tColMask = collision_mask
	tAreaColMask = $Area2D.collision_mask
	
	collision_layer = 0
	$Area2D.collision_layer = 0
	collision_mask = 0
	$Area2D.collision_mask = 0

func enable_collision():
	collision_layer = tColLayers
	$Area2D.collision_layer = tAreaColLayers
	collision_mask = tColMask
	$Area2D.collision_mask = tAreaColMask

func set_hp(value):
	if hp == null:
		hp = value
		return
	if typeof(value) != TYPE_NIL:
		hp = min(hp + value, maxHP)
		
func remove_status(status : Node):
	statusEffects.erase(status.name)

func apply_status(status : Node):
	status.entity = self
	if statusEffects.has(status.name):
		statusEffects[status.name].add_stack()
	else:
		add_child(status)
		statusEffects[status.name] = status
		status.removed.connect(remove_status)
		status.apply()

