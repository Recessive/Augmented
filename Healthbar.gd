extends Node2D

@export var status_rects : Array[TextureRect]

var stati : Array[String]
var anis : Array[AnimatedTexture]

var maxHP : float : set = set_maxHP

func set_maxHP(value):
	$Value/Label.text = str(value)
	maxHP = value

func updateHP(hp : float):
	$Fore.scale.x = hp / maxHP
	$Value/Label.text = str(hp)

func add_status(name : String, aniText : AnimatedTexture):
	if stati.has(name):
		return
	status_rects[stati.size()].texture = aniText
	stati.append(name)
	anis.append(aniText)
	
func remove_status(name):
	var ind = stati.find(name)
	stati.remove_at(ind)
	anis.remove_at(ind)
	for i in range(status_rects.size()):
		if i >= anis.size():
			status_rects[i].texture = null
		else:
			status_rects[i].texture = anis[i]
		
	
