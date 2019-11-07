class_name LogicGate

var inserted

func get_distance_to_destination(destination, pos):
	var heading = destination - pos
	return heading.length()
	
func process_movement(delta, should_snap, destination, node):
	if destination and !should_snap:
		if get_distance_to_destination(destination, node.position) > 0.01:
			node.position = node.position.linear_interpolate(destination, delta * 10)
		else:
			node.position = destination
			destination = null
	elif destination and should_snap:
		node.position = destination

func update_text(value, text):
	text.text = str(value)