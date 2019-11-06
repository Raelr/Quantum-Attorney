extends Node2D

var wires

func _ready():
	 wires = get_children()
	
func check_wires(coords): 
	#print(coords)
	for wire in wires:
		var is_in = wire.check_in_bounds(coords)
		if is_in:
			print(wire)
			return wire
