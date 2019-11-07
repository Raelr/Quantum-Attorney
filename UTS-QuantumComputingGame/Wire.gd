extends Node2D

var bit
var wire_positions
var wire_gates
var changed
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
	wire_positions = get_children()
	for object in wire_positions: 
		if object.name.find("Wire") == -1:
			if object.name.find("Kinematic"):
				bit = object
			wire_positions.erase(object)
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

