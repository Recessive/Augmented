extends "res://Scripts/Base/EnemyBase.gd"

@export
var DAMAGE : float

@export
var attackSpeed : int # in beats

@export
var shootCount : int

@export
var shootOffset : int

@export
var projectile : PackedScene

var lastShot : int
var lastShotTime : float

var player : Node

func _ready():
	_parent_ready()
	var h = PlayerStats.get_heat_scale()
	DAMAGE = floor(DAMAGE * h)
	Conductor.onBeat.connect(beat)
	player = PlayerStats.player
	
	lastShot = Conductor.beatNumber
	lastShotTime = Conductor.songPosition
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
	if (beat + shootOffset) % attackSpeed == 0:
		SfxDeconflicter.play($Shoot)
		lastShot = beat
		lastShotTime = Conductor.BeatToTime(lastShot)
		var baseAngle = global_position.angle_to_point(player.global_position)
		var angle = baseAngle - PI/4
		var direc
		var vel
		var b : Node
		for i in range(shootCount):
			b = projectile.instantiate()
			b.DAMAGE = DAMAGE
			direc = Vector2(cos(angle), sin(angle))
			vel = direc * b.SPEED
			PlayerStats.disposables.add_child(b)
			b.global_position = global_position + direc * 4
			b.velocity = vel
			
			angle += (PI/2) / shootCount
		
