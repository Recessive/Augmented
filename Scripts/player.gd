extends CharacterBody2D

@export
var SPEED : float

@export
var ACCELERATION : float

func _physics_process(delta):
	
	
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direc = Vector2(0, 0)
	var lr = Input.get_axis("ui_left", "ui_right")
	var ud = Input.get_axis("ui_up", "ui_down")
	if lr:
		direc.x += lr
	if ud:
		direc.y += ud
	
	direc = direc.normalized()
	
	velocity = velocity.move_toward(direc * SPEED, ACCELERATION * delta)
	move_and_slide()
