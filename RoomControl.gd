extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	get_child(0).new_room.connect(new_room)
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func new_room(room : Room):
	remove_child(get_child(0))
	var dir = DirAccess.open(room.path)
	var files = dir.get_files()
	# Assuming equal weighting of each room here
	var fname = files[randi_range(0, files.size()-1)]
	var next_room = load(room.path + fname).instantiate()
	add_child(next_room)
