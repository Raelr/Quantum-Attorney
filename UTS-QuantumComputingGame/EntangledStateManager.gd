class_name EntangledStateManager

var entangled_wires = {}

func on_create(wires):
	for wire in wires:
		entangled_wires[wire] = Array()

func update_entangled_wires(wire, other):
	if entangled_wires.has(wire):
		if not entangled_wires[wire].has(other):
			entangled_wires[wire].append(other)
	else:
		entangled_wires[wire] = [other]

func is_entangled(wire):
	return entangled_wires.has(wire) and entangled_wires[wire].size() > 0

func reset(wires):
	entangled_wires.clear()
	on_create(wires)

func update_entangled_states(wire, state):
	var entangled = entangled_wires[wire]
	for bit in entangled:
		bit.bit_value = state
		on_update(bit, wire, state)

func on_update(bit, called_wire, state):
	var entangled = entangled_wires[bit]
	for value in entangled:
		if not value == called_wire:
			value.bit_value = state
			on_update(value, bit, state)

func disentangle(wire, other):
	var entangled_bits = entangled_wires[wire]
	if entangled_bits.find(other) != -1:
		entangled_bits.erase(other)
	entangled_bits = entangled_wires[other]
	if entangled_bits.find(wire) != -1:
		entangled_bits.erase(wire)