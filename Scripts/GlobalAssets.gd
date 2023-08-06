extends Node2D

@export
var damageNumber : PackedScene

var atUpgradeStation : bool = false

signal combatStart
signal combatEnd


func SpawnDamageNumber(damage : float, pos : Vector2):
	var e = damageNumber.instantiate()
	get_tree().get_root().add_child(e)
	e.global_position = pos
	
	e.label.text = str(damage)

func SpawnText(text : String, pos : Vector2):
	_SpawnText(text, pos, Color.WHITE, Vector2(0.5, 0.5))

func _SpawnText(text : String, pos : Vector2, col : Color, scale : Vector2):
	var e = damageNumber.instantiate()
	get_tree().get_root().add_child(e)
	e.global_position = pos
	e.scale = scale
	
	e.label.text = text
	e.label.modulate = col
