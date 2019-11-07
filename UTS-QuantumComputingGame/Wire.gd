extends Node2D

onready var bit = $KinematicBody2D
onready var wire_positions = $WireSegments.get_children()
onready var wire_gates = $WireSegments.get_children()
onready var shape = get_node("Area2D/CollisionShape2D")

var extents
var top_right
var bottom_right
var top_left
var bottom_left

class SlotInfo:
	var slot_info
	var idx
	
func _ready():
	bit.is_movable = false
	init_shape_extents()

func init_shape_extents():
	extents = shape.shape.extents
	var length = extents.x
	var height = extents.y
	
	top_right = Vector2(shape.global_position.x + length, shape.global_position.y + height)
	bottom_right = Vector2(shape.global_position.x + length, shape.global_position.y -height)
	top_left = Vector2(shape.global_position.x -length, shape.global_position.y + height)
	bottom_left = Vector2(shape.global_position.x -length, shape.global_position.y -height)

func spawn_UI(new_pos):
	var new = preload("res://UI.tscn").instance()
	new.scale.y = 1.3
	new.position = new_pos
	add_child(new)
	new.initialise(false)

func insert(gate, idx):
	if idx < wire_gates.size() and idx >= 0:
		var existing_value = wire_gates[idx]
		if !(existing_value is Sprite) and existing_value != self:
			destroy_gate(existing_value)
		gate.logic_gate.inserted = true
		wire_gates[idx] = gate

func destroy_gate(gate):
	var btn = get_tree().get_nodes_in_group("bitButton")[0]
	gate.logic_gate.destroy = true
	gate.is_movable = false
	gate.destination = btn.position

func remove(idx):
	var gate
	if idx < wire_gates.size() and idx >= 0:
		gate = wire_gates[idx]
		if !(gate is Sprite):
			gate.logic_gate.inserted = false
			wire_gates[idx] = wire_positions[idx]
			return gate


func check_in_bounds(coords): 
	var min_x = top_left.x
	var max_x = top_right.x
	var min_y = bottom_right.y
	var max_y = top_right.y
	var x = coords.x < max_x and coords.x > min_x
	var y = coords.y < max_y and coords.y > min_y
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

