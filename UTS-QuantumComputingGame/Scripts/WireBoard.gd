extends Node2D

var wires

func _ready():
	 wires = get_children()

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

func get_wire_info(wire, coords):
	if wire:
		var info = wire.get_closest_slot(coords)
		return info