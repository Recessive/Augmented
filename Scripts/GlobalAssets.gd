extends Node2D

@export
var damageNumber : PackedScene

var atUpgradeStation : bool = false

func SpawnDamageNumber(damage : float, pos : Vector2):
	var e = damageNumber.instantiate()
	get_tree().get_root().add_child(e)
	e.global_position = pos
	
	e.label.text = str(damage)
