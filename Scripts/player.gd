extends CharacterBody2D

@export
var SPEED : float


func _physics_process(delta):
	
	velocity = Vector2(0, 0)
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var lr = Input.get_axis("ui_left", "ui_right")
	var ud = Input.get_axis("ui_up", "ui_down")
	if lr:
		velocity.x = lr * SPEED
	if ud:
		velocity.y = ud * SPEED

	move_and_slide()
