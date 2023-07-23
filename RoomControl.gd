extends Node

@export
var player : Node

# Called when the node enters the scene tree for the first time.
func _ready():
	get_child(0).new_room.connect(new_room)
	
	pass # Replace with function body.

var make_room : Room = null
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if make_room:
		var dir = DirAccess.open(make_room.path)
		var files = dir.get_files()
		# Assuming equal weighting of each room here
		var fname = files[randi_range(0, files.size()-1)]
		var next_room = load(make_room.path + fname).instantiate()
		next_room.new_room.connect(new_room)
		add_child(next_room)
		make_room = null

func new_room(room : Room):
	player.position = Vector2(0, 0)
	get_child(0).queue_free()
	make_room = room
	# Make the room on the next frame to prevent double collisions
	
	
