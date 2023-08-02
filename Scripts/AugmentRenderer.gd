extends Node2D

var limbs : Array

func _ready():
	limbs = [
		$Head,
		$Body,
		$LeftArm,
		$RightArm,
		$LeftLeg,
		$RightLeg
	]

func flip_h(state : bool):
	for child in limbs:
		child.flip_h = state

func start_all(anim):
	for child in limbs:
		child.play(anim)

func stop_all():
	for child in limbs:
		child.stop()
