class_name RandPlus

static func SampleWeighted(weights : Array) -> int:
	# Returns a randomly selected index of weights
	
	# Get probabilities of each item
	var total : float = sum(weights)
	var probs = weights.map(func(x): return x/total)
	
	var randomNum = randf()
	var c : float = 0
	for i in probs.size():
		c += probs[i]
		if randomNum < c:
			return i
		
	
	push_error("Invalid probability!")
	return -1

static func sum(arr : Array) -> float:
	return arr.reduce(func(a, b): return a + b, 0)
