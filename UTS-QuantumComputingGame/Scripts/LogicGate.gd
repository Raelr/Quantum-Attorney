class_name LogicGate
const utils = preload("Util.gd")
var inserted
var destroy
var destination
var is_movable

func get_distance_to_destination(pos):
	var heading = destination - pos
	return heading.length()

func update_text(value, text):
	text.text = str(value) 

func process_movement(delta, should_snap, node):
	if destination and !should_snap:
		if utils.get_distance(node.position, destination) > 0.01:
			node.position = node.position.linear_interpolate(destination, delta * 10)
		else:
			node.position = destination
			if destroy:
				node.queue_free()
			destination = null
	elif destination and should_snap:
		node.position = destination