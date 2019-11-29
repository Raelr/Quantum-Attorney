extends Node2D
var wires
export (Array) var bits
var circuit_state
var maths = MathUtils.new()
var gate_iterations
var amplitude = AmplitudeCalculator.new()
var entangled_bits_manager = EntangledStateManager.new()

func _ready():
	wires = get_children()
	var idx = 0
	for wire in wires:
		wire.idx = idx
		idx+=1
	idx = 0
	for value in bits:
		wires[idx].bit.set_bit(convert_to_vec(value))
		idx+=1
	gate_iterations = wires[0].wire_gates.size()
	entangled_bits_manager.on_create(wires)
	process_bits()

func insert_gate(gate, coords):
	var slot = get_wire_slot(gate.position)
	var wire = get_wire(coords)
	if slot:
		gate.z_index = 0
		gate.set_destination(slot.slot_info.global_position, false)
	else:
		gate.destroy_after_movement()
	if wire:
		wire.insert(gate, slot.idx)
		gate.on_insert(self, wire, slot)
		process_bits()

func get_wire(coords): 
	for wire in wires:
		var is_in = wire.check_in_bounds(coords)
		if is_in:
			return wire

func get_wire_slot(coords):
	return get_wire_info(get_wire(coords), coords)

func remove_gate(coords):
	var wire = get_wire(coords)
	var info = get_wire_info(wire, coords)
	if wire:
		var removed = wire.remove(info.idx)
		process_bits()
		return removed

func convert_to_vec(value):
		if value == 0: 
			return [1, 0]
		else: 
			return [0,value]

func get_wire_info(wire, coords):
	if wire:
		var info = wire.get_closest_slot(coords)
		return info

func process_bits():
	var all_bits = Array()
	entangled_bits_manager.reset(wires)
	for value in bits:
		all_bits.append(convert_to_vec(value))
	circuit_state = maths.tensor(all_bits)
	for wire in wires:
		wire.reset()
	for i in range(0, gate_iterations):
		var wire_values = Array()
		for wire in wires:
			var val = wire.process_bit(i, self)
			if val:
				if val[1]:
					entangled_bits_manager.update_entangled_wires(wire, val[1])
					entangled_bits_manager.update_entangled_wires(val[1], wire)
					entangled_bits_manager.update_entangled_states(wire, val[0])
			if entangled_bits_manager.is_entangled(wire):
				entangled_bits_manager.update_entangled_states(wire, val[0])
			if not (entangled_bits_manager.is_entangled(wire) and wire_values.find(val[0]) != -1):
				wire_values.append(val[0])
		circuit_state = maths.tensor(wire_values)
		print(wire_values)
	print("Circuit State: ", circuit_state)
	update_wires(amplitude.assign_amplitude(circuit_state, maths, wires.size()))

func update_wires(wire_vals):
	for i in range(0, wire_vals.size()):
		wires[i].output.text = str(wire_vals[i])