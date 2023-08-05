extends Resource

class_name Room

# Unfortunately this needs to be a string instead of a packed scene because Godot is silly.. I think
# At the very least the error it throws is confusing af and corrupts the scene
# https://github.com/godotengine/godot/issues/64330
@export
var rooms : Array[String]

@export
var weight : float

@export
var type : String


