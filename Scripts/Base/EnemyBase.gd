extends "res://Scripts/Base/EntityBase.gd"

@export
var CONTACT_DAMAGE : float

@export
var CONTACT_PENETRATION : float

@export
var CONTACT_KNOCKBACK : float


func contact_damage(body : Node, knockback_pos : Vector2):
	var attack = Attack.new()
	attack.damage = CONTACT_DAMAGE
	attack.penetration = CONTACT_PENETRATION
	attack.knockback = CONTACT_KNOCKBACK
	attack.pos = knockback_pos
	body.hurt(attack)


func _on_area_2d_body_entered(body):
	if body.is_in_group("Player"):
		contact_damage(body, sprite.global_position)
