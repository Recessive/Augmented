extends "res://Scripts/Base/EnemyBase.gd"

@export
var toSpawn : PackedScene

@export
var spawnSpeed : int # in beats

@export
var customSpawnValues : Dictionary

var lastSpawn : int
var lastSpawnTime : float

func _ready():
	_parent_ready()
	Conductor.onBeat.connect(beat)
	
	lastSpawn = Conductor.beatNumber
	lastSpawnTime = Conductor.songPosition
	$AnimationPlayer.play("spawn")

@onready
var spawnAniLength : float = $AnimationPlayer.get_animation("spawn").length
func _process(delta):
	var p : float = (Conductor.songPosition - lastSpawnTime) / (Conductor.BeatToTime(lastSpawn + spawnSpeed) - lastSpawnTime)
	if p > 1:
		return
	$AnimationPlayer.seek(p * spawnAniLength)

func beat(enabled : Array[bool], beat : int):
	if dead:
		return
	if beat % spawnSpeed == 0:
		$SpawnSound.play()
		lastSpawn = beat
		lastSpawnTime = Conductor.BeatToTime(lastSpawn)
		
		
		var o = toSpawn.instantiate()
		o.global_position = global_position
		o.dontDrop = true
		for key in customSpawnValues:
			o.set(key, customSpawnValues[key])
		get_parent().add_child(o)
		
