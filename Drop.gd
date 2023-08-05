extends AnimatedSprite2D


@export
var dropName : String

@export
var weight : float

@export
var tier : int

func _ready():
	var key = str(InputMap.action_get_events("interact")[0].as_text().split(" ")[0])
	$Label.text = $Label.text % key

func _process(delta):
	if Input.is_action_pressed("interact") and playerIn:
		if PlayerStats.can_add_item(tier, dropName):
			PlayerStats.add_item(tier, dropName)
			queue_free()
		else:
			if tier == 1:
				GlobalAssets.SpawnText("No room in tier 1 inventory!", $Label.global_position)
			else:
				GlobalAssets.SpawnText("No room in tier 2 inventory!", $Label.global_position)


var playerIn : bool = false
func _on_area_2d_body_entered(body : Node):
	if body.is_in_group("Player"):
		playerIn = true
		$Label.visible = true



func _on_area_2d_body_exited(body):
	if body.is_in_group("Player"):
		playerIn = false
		$Label.visible = false
