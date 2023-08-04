extends AudioStreamPlayer

@export
var beatFilePath : String


func _ready():
	Conductor.init(self, beatFilePath)
	play_song()

func play_song():
	await finished
	Conductor.next_song()
