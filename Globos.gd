extends Node2D

@export
var DAMAGE : float

@export
var PENETRATION : float

@export
var KNOCKBACK : float

@export
var moveCurve : Curve

@export
var beatIndex : int

@export
var chargeBeats : int

@onready
var character : CharacterBody2D = $Character

@onready
var line : Line2D = $Line2D

@onready
var space = get_world_2d().direct_space_state

var charging = false
var angle = randf_range(0, 2 * PI)
var direc = Vector2(cos(angle), sin(angle))

@onready
var target : Vector2 = global_position
@onready
var pivot : Vector2 = global_position

func _ready():
	Conductor.onBeat.connect(beat)
	line.add_point(Vector2(0, 0))


func _physics_process(delta):
	
	# Fire a ray that bounces 4 times
	# Then shoot itself along the ray 4 times stopping after the 4th bounce
	
	# TO THE BEAT
	character.global_position = pivot + (target - pivot) * moveCurve.sample(Conductor.percentage_enabled(beatIndex))
	# line.set_point_position(0, character.position)

	# var col = move_and_collide(direc * SPEED * delta)
	# if col:
	# 	direc = direc.bounce(col.get_normal())
	pass




func _on_player_hurt_body_entered(body : Node):
	if body.is_in_group("Player"):
		var attack = Attack.new()
		attack.damage = DAMAGE
		attack.penetration = PENETRATION
		attack.knockback = KNOCKBACK
		attack.pos = global_position
		body.hurt(attack)

var prepping : bool = true
var result
func beat(enabled : Array[bool], beat : int):
	if(enabled[beatIndex]):
		if prepping:
			pivot = target
			var pos
			if(line.points.size() == 1):
				pos = global_position
			else:
				pos = result.position
			
			# Magic value:
			# 10,000: make raycast long
			# 0x00000001: Only collide with wall layer
			var query = PhysicsRayQueryParameters2D.create(pos, direc*10000, 0x00000001)
			result = space.intersect_ray(query)

			line.add_point(line.to_local(result.position))
			direc = direc.bounce(result.normal)
			if line.points.size() >= chargeBeats + 1:
				prepping = false
		else:
			pivot = line.to_global(line.points[0])
			target = line.to_global(line.points[1])
			line.remove_point(0)
			if line.points.size() == 1:
				angle = randf_range(0, 2 * PI)
				direc = Vector2(cos(angle), sin(angle))
				prepping = true
