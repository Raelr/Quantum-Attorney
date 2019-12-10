extends Node2D
const util = preload("Util.gd")
onready var wireboard = get_node("/root/Node2D/WireBoard")
onready var raycast = RayCastController.new()
var jury 
var target
var previous_target
var is_held : bool
var offset = Vector2()
var maths = MathUtils.new()

func check_input(delta):
	var mouse_pos = get_global_mouse_position()
	if Input.is_action_just_pressed("left_click"):
		
		target = set_target(raycast.raycast_for_groups(self, mouse_pos, ["LogicGate", "button"]))
		if target:
			offset = util.get_offset(target.position, mouse_pos, position)
	elif Input.is_action_pressed("left_click") and !is_held:
			is_held = true
	elif Input.is_action_just_released("left_click") and target:
		target = remove_target(target)
	if target:
		set_target_for_movement(mouse_pos + offset, target)

func check_for_insertable_slot(target):
	wireboard.insert_gate(target, target.position)
	return target

func set_target_for_movement(pos, target):
	if target.is_movable() and is_held:
		target.set_destination(pos, true)

func set_target(new_target):
	if new_target:
		new_target.z_index = 1
		new_target = check_if_button(new_target)
	if new_target and new_target.logic_gate.inserted:
		wireboard.remove_gate(new_target.position)
	return new_target

func check_if_button(target):
	if target.name.find("Button") != -1:
		target = target.on_click(target.position, self)
	return target

func remove_target(target):
	if target and target.is_movable():
		target = check_for_insertable_slot(target)
	is_held = false 
	previous_target = target
	target = null
	return target

func _process(delta):
	check_input(delta)