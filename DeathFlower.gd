extends "res://Scripts/Base/EnemyBase.gd"

func _on_area_2d_body_entered(body):
	contact_damage(body,global_position)
	explode()

func explode():
	$Sprite2D/Healthbar.visible = false
	disable_collision()
	$Sprite2D/Animation.play('explode')
	await $Sprite2D/Animation.animation_finished
	queue_free()
