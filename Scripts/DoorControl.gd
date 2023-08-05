extends TileMap

@export
var enemies : Array[Node]

@export
var doorNodes : Array[StaticBody2D]

# Godot is a piece of shit, if this variable is called "roomTypes" it doesnt work in the export
# menu. LITERALLY ANY OTHER NAME WORKS THOUGH
@export
var roomTypeList : Array[Room]

var doorDestinations : Array[Room]

var spawn : Vector2

signal new_room
signal room_ready

func _ready():
	for enemy in enemies:
		enemy.died.connect(enemy_died)
	
	# assign a room type to each door in this room
	var roomWeights = []
	for room in roomTypeList:
		roomWeights.append(room.weight)

	
	var ind
	for i in doorNodes.size():
		
		ind = RandPlus.SampleWeighted(roomWeights)
		doorDestinations.append(roomTypeList[ind])
		match roomTypeList[ind].type:
			"cyber":
				doorNodes[i].get_node("AnimatedSprite2D").animation = "open"
			"cyber_aug":
				doorNodes[i].get_node("AnimatedSprite2D").animation = "open_aug"
			
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
	if enemies.size() == 0:
		var ind = doorNodes.find(x)
		emit_signal("new_room", doorDestinations[ind])
