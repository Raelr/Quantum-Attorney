extends Node2D
onready var bit = $Bit
onready var wire_positions = $WireSegments.get_children()
onready var wire_gates = $WireSegments.get_children()
onready var shape = get_node("Area2D/CollisionShape2D")
onready var top_right = Vector2(shape.global_position.x + shape.shape.extents.x, shape.global_position.y + shape.shape.extents.y)
onready var bottom_right = Vector2(shape.global_position.x + shape.shape.extents.x, shape.global_position.y -shape.shape.extents.y)
onready var top_left = Vector2(shape.global_position.x -shape.shape.extents.x, shape.global_position.y + shape.shape.extents.y)

class SlotInfo:
	var slot_info
	var idx
 
func insert(gate, idx):
	if idx < wire_gates.size() and idx >= 0:
		var existing_value = wire_gates[idx]
		if !(existing_value is Sprite) and existing_value != self:
			destroy_gate(existing_value)
		gate.logic_gate.inserted = true
		wire_gates[idx] = gate

func destroy_gate(gate):
	var btn = get_tree().get_nodes_in_group("bitButton")[0]
	gate.remove_from_group("LogicGate")
	gate.logic_gate.destroy = true
	gate.set_movable(false) 
	gate.set_destination(btn.position, false)

func remove(idx):
	var gate
	if idx < wire_gates.size() and idx >= 0:
		gate = wire_gates[idx]
		if !(gate is Sprite):
			gate.logic_gate.inserted = false
			wire_gates[idx] = wire_positions[idx]
			return gate

func check_in_bounds(coords): 
	var x = coords.x < top_right.x and coords.x > top_left.x  
	var y = coords.y < top_right.y and coords.y > bottom_right.y
	return x and y

func get_closest_slot(coords):
	var closest
	var min_dist = 10000000
	var idx = 0
	for pos in wire_positions:
		var dist = (coords - pos.global_position).length()
		if  dist < min_dist:
			closest = SlotInfo.new() 
			closest.slot_info = pos
			closest.idx = idx
			min_dist = dist
		idx += 1
	return closest