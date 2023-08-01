extends Sprite2D

@export
var beatIndex : int

@export
var startColor : Color

@export
var pulseColor : Color

@export
var pulseCurve : Curve

func _process(delta):
		var p = Conductor.percentage_enabled(beatIndex)
		modulate = lerp(startColor, pulseColor, pulseCurve.sample(p))
	
