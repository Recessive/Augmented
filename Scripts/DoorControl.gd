extends TileMap

@export
var enemies : Array[Node]

@export
var doorNodes : Array[RigidBody2D]

@export
var roomTypes : Array[Room]

var doorDestinations : Array[Room]

var spawn : Vector2

signal new_room
signal room_ready

func _ready():
	for enemy in enemies:
		enemy.died.connect(enemy_died)
	
	# assign a room type to each door in this room
	var roomWeights = []
	for room in roomTypes:
		roomWeights.append(room.weight)
	
	var ind
	for i in doorNodes.size():
		
		ind = RandPlus.SampleWeighted(roomWeights)
		doorDestinations.append(roomTypes[ind])
		# TODO: Change the sprite to reflect its room type
	
	# Connect parent to signals emitted from children (call down, signal up)
	for doorNode in doorNodes:
		doorNode.door_entered.connect(door_triggered)
		
	spawn = $Spawn.position
	spawn.y -= 32
	
	emit_signal("room_ready")

func enemy_died(enemy : Node):
	enemies.remove_at(enemies.find(enemy))
	if enemies.size() == 0:
		for doorNode in doorNodes:
			doorNode.get_child(0).play()

func play_door_ani():
	$Spawn.play()
	if enemies.size() == 0:
		for doorNode in doorNodes:
			doorNode.get_child(0).play()
	
func door_triggered(x : Node):
	
	var ind = doorNodes.find(x)
	emit_signal("new_room", doorDestinations[ind])
	pass
