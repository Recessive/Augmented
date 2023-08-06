extends Area2D



var hardModeOn = false
func _on_body_entered(body):
	if hardModeOn:
		return
	hardModeOn = true
	PlayerStats.heat = 5
	PlayerStats.maxHP /= 2
	PlayerStats.hp = PlayerStats.maxHP
	
	GlobalAssets._SpawnText("HARD MODE ACTIVE", Vector2(), Color.RED, Vector2(2, 2))
