extends Node

signal enemies_dead
signal entered_combat

@export
var disposables : Node

@export
var player : Node

@export
var fade : ColorRect

@export
var fadeBeatIndex : int = 3

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
		player.start_invi()
		$"../EnterRoom".play()
		make_room = room
		fade.show()
		fading = true
		
		
		room_pause(true)
		# Make the room fade out and fade in
	
func room_ready():
	
	$/root/main/HUD.update_camera()
	player.position = current_room.spawn
	
	# increase depth for each room
	PlayerStats.depth += 1
	if PlayerStats.depth % 10 == 0 or (PlayerStats.heat >= 10 and PlayerStats.depth % 5 == 0):
		PlayerStats.heat += 1# increase heat once for each 10 rooms you go through
	
	if PlayerStats.depth != 1:
		GlobalAssets.SpawnText("Depth +1", Vector2(0, -16))
	
	PlayerStats.proc_new_room()

func all_enemies_dead():
	emit_signal("enemies_dead")

func start_combat():
	emit_signal("entered_combat")

func beat(enabled : Array[bool], beat : int):
	if enabled[fadeBeatIndex] and fading:
		if fadeOut:
			fadeOut = false
			get_child(0).queue_free()
			PlayerStats.delete_children(disposables)
			var res
			if PlayerStats.heat >= PlayerStats.highHeat:
				res = make_room.highHeatRooms[randi_range(0, make_room.highHeatRooms.size()-1)]
			else:
				res = make_room.rooms[randi_range(0, make_room.rooms.size()-1)]
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
