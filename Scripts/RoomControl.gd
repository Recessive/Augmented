extends Node

@export
var disposables : Node

@export
var player : Node

@export
var fade : ColorRect

@export
var fadeBeatIndex : int = 3

var depth : int = 0
var heat : int = 0

var fading : bool = false
var fadeOut : bool = true

func _ready():
	
	var child = get_child(0)
	child.new_room.connect(new_room)
	Conductor.onBeat.connect(beat)
	current_room.play_door_ani()
	room_ready()

var make_room : Room = null

@onready
var current_room : Node = get_child(0)

func _process(delta):
	if fading:
		if fadeOut:
			fade.modulate.a = Conductor.percentage_enabled(fadeBeatIndex)
		else:
			fade.modulate.a = 1-Conductor.percentage_enabled(fadeBeatIndex)

func room_pause(pause : bool):
	var procMode
	if pause:
		procMode = Node.PROCESS_MODE_DISABLED
	else:
		procMode = Node.PROCESS_MODE_INHERIT
	PlayerStats.locked = pause
	disposables.set_deferred("process_mode", procMode)
	current_room.set_deferred("process_mode", procMode)

func new_room(room : Room):
	if make_room == null and !fading:
		make_room = room
		fade.show()
		fading = true
		room_pause(true)
		# Make the room fade out and fade in
	
func room_ready():
	
	player.position = current_room.spawn
	
	$/root/main/HUD.update_camera()
	
	# increase depth for each room
	depth += 1
	heat = depth / 10 # temporary increase heat once for each 10 rooms you go through
	
	if depth != 1:
		GlobalAssets.SpawnText("Depth +1", Vector2(-16, 0))

func beat(enabled : Array[bool], beat : int):
	if enabled[fadeBeatIndex] and fading:
		if fadeOut:
			fadeOut = false
			get_child(0).queue_free()
			PlayerStats.delete_children(disposables)
			var res = make_room.rooms[randi_range(0, make_room.rooms.size()-1)]
			var next_room = load(res).instantiate()
			current_room = next_room
			next_room.new_room.connect(new_room)
			next_room.room_ready.connect(room_ready)
			add_child(next_room)
			make_room = null
		else:
			current_room.play_door_ani()
			fade.hide()
			fadeOut = true
			fading = false
			room_pause(false)
