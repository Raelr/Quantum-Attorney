extends Node2D

var wires

func _ready():
	 wires = get_children()
	
func check_wires(coords): 
	var target_wire
	for wire in wires:
		var is_in = wire.check_in_bounds(coords)
		if is_in:
			target_wire = wire
			break
	if target_wire:
		return target_wire.get_closest_slot(coords)