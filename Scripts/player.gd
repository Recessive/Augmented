extends CharacterBody2D

func _physics_process(delta):
	
	var direc = Vector2(0, 0)
	var lr = Input.get_axis("ui_left", "ui_right")
	var ud = Input.get_axis("ui_up", "ui_down")
	if lr:
		direc.x += lr
	if ud:
		direc.y += ud
		
	direc = direc.normalized()
	
	velocity = velocity.move_toward(direc * PlayerStats.maxSpeed, PlayerStats.acceleration * delta)
	move_and_slide()

func hurt(attack : Attack):
	PlayerStats.hp -= attack.damage
	velocity = (global_position - attack.pos).normalized() * attack.knockback
	pass
