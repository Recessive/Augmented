extends Node

class_name AugmentData

'''
AUGMENT DATA STRUCTURE:
	<AUGMENT NAME>  # e.g. predator
		COST        # crafting requirements
			BATTERY # for blast
			COIL    # for shoot
			GEAR    # for movement
			PLATE   # for health
		COLOR       # e.g. Color(1.0, 0.0, 0.0)
		MODIFIERS   # some linear expressions will be used to convert these into the actual stat block
			BLAST   # was implemented in my demo instead of melee
			SHOOT   # can increase bullet count/speed/size/damage
			MOVE    # movement speed (maybe add a dash later)
			HEALTH  # max hitpoints

# sum of costs should be the same as sum of modifiers
'''

const AUGMENTS = {
	"none": { # always used in a slot where there is no augment equipped
		"cost": {
			"battery": 0,
			"coil": 0,
			"gear": 0,
			"plate": 0,
		},
		"color": Color(0.0, 0.0, 0.0, 0.0), # just in case the limb is not hidden when it should be
		"modifiers": {
			"blast": 0,
			"shoot": 0,
			"move": 0,
			"health": 0,
		}
	},
	"basic": {
		"cost": {
			"battery": 1,
			"coil": 1,
			"gear": 1,
			"plate": 1,
		},
		"color": Color(1.0, 1.0, 1.0),
		"modifiers": {
			"blast": 1,
			"shoot": 1,
			"move": 1,
			"health": 1,
		}
	},
	"predator": {
		"cost": {
			"battery": 2,
			"coil": 1,
			"gear": 0,
			"plate": 0,
		},
		"color": Color(1.0, 0.0, 0.0),
		"modifiers": {
			"blast": 3,
			"shoot": 1,
			"move": 0,
			"health": 0,
		}
	},
}
