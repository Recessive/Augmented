extends "res://Scripts/Base/EntityBase.gd"

@export
var SPEED : float

@export
var DAMAGE : float

@export
var PENETRATION : float

@export
var KNOCKBACK : float

@export
var targetGroup : String = "Enemy"

@export
var fireBeats : int = 1

func _physics_process(delta):
	move_and_collide(velocity)

func damage_body(pos : Vector2, body : Node):
	var attack = Attack.new()
	attack.damage = randi_range(0, 100)
	attack.penetration = PENETRATION
	attack.knockback = KNOCKBACK
	attack.pos = pos
	body.hurt(attack)

func _on_area_2d_body_entered(body):
	if body.is_in_group(targetGroup):
		damage_body(global_position, body)
	queue_free()
		


func _on_area_2d_area_entered(area):
	if area.is_in_group(targetGroup):
		damage_body(global_position, area.parent)
	queue_free()

