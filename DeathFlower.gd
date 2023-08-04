extends "res://Scripts/Base/EnemyBase.gd"



func _on_area_2d_body_entered(body):
	
	explode()

func explode():
	$Sprite2D/Animation.play('explode')
