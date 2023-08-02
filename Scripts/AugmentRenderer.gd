extends Node2D

var limbs : Dictionary

func _ready():
	limbs = {
		"head":$Head,
		"body":$Body,
		"leftarm":$LeftArm,
		"rightarm":$RightArm,
		"leftleg":$LeftLeg,
		"rightleg":$RightLeg
	}
	
	update()

func update():
	for limb in limbs:
		var augment_name = PlayerStats.augments[limb]
		var augment = AugmentData.AUGMENTS[augment_name]
		if augment_name == 'none':
			limbs[limb].hide()
		else:
			limbs[limb].show()
			limbs[limb].modulate = augment['color']

func flip_h(state : bool):
	for child in limbs.values():
		child.flip_h = state

func start_all(anim):
	for child in limbs.values():
		child.play(anim)

func stop_all():
	for child in limbs.values():
		child.stop()
