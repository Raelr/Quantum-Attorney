extends Node2D

var wires

func _ready():
	 wires = get_children()

func insert_gate(gate, coords, idx):
	var wire = get_wire(coords)
	if wire:
		wire.insert(gate, idx)

func get_wire(coords): 
	var target_wire
	for wire in wires:
		var is_in = wire.check_in_bounds(coords)
		if is_in:
			return wire

func remove_gate(coords):
	var wire = get_wire(coords)
	var info = get_wire_info(wire, coords)
	if wire:
		wire.remove(info.idx)

func get_wire_info(wire, coords):
	if wire:
		var info = wire.get_closest_slot(coords)
		return info