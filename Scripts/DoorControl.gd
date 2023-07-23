extends TileMap

@export
var doorNodes : Array[Area2D]

@export
var roomTypes : Array[Room]

var doorDestinations : Array[Room]

signal new_room

# Called when the node enters the scene tree for the first time.
func _ready():
	# assign a room type to each door in this room
	var roomWeights = []
	for room in roomTypes:
		roomWeights.append(room.weight)
	
	var ind
	for i in doorNodes.size():
		ind = RandPlus.SampleWeighted(roomWeights)
		doorDestinations.append(roomTypes[ind])
	
	# Connect parent to signals emitted from children (call down, signal up)
	for doorNode in doorNodes:
		doorNode.door_entered.connect(door_triggered)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func door_triggered(x : Node):
	var ind = doorNodes.find(x)
	emit_signal("new_room", doorDestinations[ind])
	pass
