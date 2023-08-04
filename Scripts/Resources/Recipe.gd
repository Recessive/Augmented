extends Resource

class_name Recipe

@export
var tier1requirements : Dictionary

@export
var tier2requirements : Dictionary

# Head
# Body
# Legs
# Arms
@export
var bodyPart : String

@export
var productName : String

func can_afford():
	for key in tier1requirements:
		if !PlayerStats.tier1Inventory.has(key) or PlayerStats.tier1Inventory[key] < tier1requirements[key]:
			return false
	
	for key in tier2requirements:
		if !PlayerStats.tier2Inventory.has(key) or PlayerStats.tier2Inventory[key] < tier2requirements[key]:
			return false
	
	return true
