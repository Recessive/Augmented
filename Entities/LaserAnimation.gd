extends Line2D
@onready
var laserStart : CPUParticles2D  = $LaserStart
@onready
var laserEnd : CPUParticles2D = $LaserEnd

var posSet = false
func _physics_process(delta):
	if points.size() > 1:
		if !posSet:
			posSet = true
			set_pos()
			

func set_pos():
	var ang = points[0].angle_to(points[1])
	laserStart.global_rotation = ang
	laserStart.global_position = to_global(points[0])
	laserStart.emitting = true
	laserEnd.global_position = to_global(points[1])
	laserEnd.global_rotation = -ang
	laserEnd.emitting = true
