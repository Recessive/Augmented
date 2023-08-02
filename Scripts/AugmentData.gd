extends Node

'''
AUGMENT DATA STRUCTURE:
	<AUGMENT NAME>  # e.g. predator
		COST        # crafting requirements
			GEAR    # for movement
			BATTERY # for blast
			COIL    # for shoot
			PLATE   # for health
		COLOR       # e.g. Color(1.0, 0.0, 0.0)
		MODIFIERS   # some linear expressions will be used to convert these into the actual stat block
			BLAST   # was implemented in my demo instead of melee
			SHOOT   # can increase bullet count/speed/size/damage
			MOVE    # movement speed (maybe add a dash later)
			HEALTH  # max hitpoints
'''
