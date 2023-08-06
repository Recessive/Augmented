extends "res://Scripts/Base/EnemyBase.gd"


@export
var attackSpeed : int # in beats

@export
var shootCount : int

@export
var projectile : PackedScene

var lastShot : int = 0
var lastShotTime : float

var player : Node

func _ready():
	_parent_ready()
	Conductor.onBeat.connect(beat)
	player = PlayerStats.player
	
	$AnimationPlayer.play("shoot")

@onready
var shootAniLength : float = $AnimationPlayer.get_animation("shoot").length
func _process(delta):
	var p : float = (Conductor.songPosition - lastShotTime) / (Conductor.BeatToTime(lastShot + attackSpeed) - lastShotTime)
	if p > 1:
		return
	$AnimationPlayer.seek(p * shootAniLength)

func beat(enabled : Array[bool], beat : int):
	if dead:
		return
	if beat % attackSpeed == 0:
		$Shoot.play()
		lastShot = beat
		lastShotTime = Conductor.BeatToTime(lastShot)
		var baseAngle = global_position.angle_to_point(player.global_position)
		var angle = baseAngle - PI/4
		var direc
		var vel
		var b : Node
		for i in range(shootCount):
			b = projectile.instantiate()
			direc = Vector2(cos(angle), sin(angle))
			vel = direc * b.SPEED
			PlayerStats.disposables.add_child(b)
			b.global_position = global_position + direc * 4
			b.velocity = vel
			
			angle += (PI/2) / shootCount
		
