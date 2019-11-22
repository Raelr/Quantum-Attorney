class_name AmplitudeCalculator

static func assign_amplitude(state, maths, wires):
	state = sort_circuit_state(state)
	print(state)
	var min_bit = 0.0
	var ranges = Array()
	for value in state:
		min_bit += (value[1] * value[1])
		ranges.append(min_bit)
	var probability = get_random_probability(ranges)
	#print("Probability: ", probability)
	var chosen = state[probability[0]]
	#print("Chosen state: ", chosen)
	return maths.to_binary(chosen[0], wires)
	
static func get_random_probability(ranges):
	var chance = rand_range(0, 1)
	print(chance)
	for i in range(0, ranges.size()):
		#print("Range chosen: ", ranges[i])
		if chance < ranges[i]:
			return [i, chance]

static func sort_circuit_state(state):
	var full_indices = Array()
	for i in range(0, state.size()):
		if not state[i] == 0:
			 full_indices.append([i, state[i]])
	return full_indices