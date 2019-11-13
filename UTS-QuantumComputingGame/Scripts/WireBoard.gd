extends Node2D
var wires
export (Array) var bits

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
		process_bits()
		gate.on_insert(self, wire, slot)


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
		return wire.remove(info.idx)

func convert_to_vec(value):
		if value == 1: 
			return [0, 1]
		else: 
			return [1,0]

func get_wire_info(wire, coords):
	if wire:
		var info = wire.get_closest_slot(coords)
		return info

func process_bits():
	for wire in wires:
		wire.process_bits(self)