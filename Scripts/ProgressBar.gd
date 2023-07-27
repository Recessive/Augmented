extends ProgressBar


func _process(delta):
	value = Conductor.percentage_enabled(0) * 100
