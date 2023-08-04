extends "res://Scripts/Base/EnemyBase.gd"

func _ready():
	CONTACT_DAMAGE = 10

func _on_area_2d_body_entered(body):
	contact_damage(body,(body.position-position)*Vector2(10,10))
	explode()

func explode():
	$Sprite2D/Animation.play('explode')
