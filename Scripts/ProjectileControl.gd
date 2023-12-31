extends CharacterBody2D

@export
var SPEED : float

@export
var DAMAGE : float

@export
var PENETRATION : float

@export
var KNOCKBACK : float

@export
var fireBeats : int = 1

var ignoreCol = false

func _physics_process(delta):
	move_and_collide(velocity)

func damage_enemy(pos : Vector2, body : Node):
	var attack = Attack.new()
	attack.damage = randi_range(0, 100)
	attack.penetration = PENETRATION
	attack.knockback = KNOCKBACK
	attack.pos = pos
	body.hurt(attack)

func _on_area_2d_body_entered(body):
	if ignoreCol:
		return
	if body.is_in_group("Enemy"):
		damage_enemy(global_position, body)
	queue_free()
		


func _on_area_2d_area_entered(area):
	if ignoreCol:
		return
	if area.is_in_group("Enemy"):
		damage_enemy(global_position, area.parent)
	queue_free()
