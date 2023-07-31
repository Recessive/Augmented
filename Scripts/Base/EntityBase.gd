extends CharacterBody2D

@export
var maxHP : float : set = set_hp

@onready
var hp = maxHP

@onready var sprite : Sprite2D = $Sprite2D
@onready var collShape : CollisionShape2D = $CollisionShape2D
@onready var animPlayer : AnimationPlayer = $AnimationPlayer
@onready var area2d : Area2D = $Area2D

func set_hp(value):
	if hp == null:
		hp = value
		return
	if typeof(value) != TYPE_NIL:
		hp = min(hp + value, maxHP)
