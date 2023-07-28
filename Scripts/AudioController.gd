extends AudioStreamPlayer

@export
var beatFilePath : String

func _ready():
	Conductor.init(self, beatFilePath)
