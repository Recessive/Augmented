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

var pickUp = false
func _process(delta):
	if !pickUp and Input.is_action_pressed("interact") and playerIn:
		if PlayerStats.can_add_item(tier, dropName):
			pickUp = true
			PlayerStats.add_item(tier, dropName)
			visible = false
			$Area2D.collision_layer = 0
			$Area2D.collision_mask = 0
			$PickupSound.play()
			await $PickupSound.finished
			queue_free()
		elif $Timer.is_stopped():
			if tier == 1:
				GlobalAssets.SpawnText("No room in tier 1 inventory!", $Label.global_position)
			else:
				GlobalAssets.SpawnText("No room in tier 2 inventory!", $Label.global_position)
			$Timer.start()


var playerIn : bool = false
func _on_area_2d_body_entered(body : Node):
	if body.is_in_group("Player"):
		playerIn = true
		$Label.visible = true



func _on_area_2d_body_exited(body):
	if body.is_in_group("Player"):
		playerIn = false
		$Label.visible = false
