extends Node2D

var target
var target_pos
var space_state; 
var is_held : bool
var offset : Vector2
onready var wireboard = get_node("/root/Node2D/WireBoard")

func check_input():
	var mouse_pos = get_global_mouse_position()
	if Input.is_action_just_pressed("left_click"):
		target = set_target(check_for_ray_target(mouse_pos))
	elif Input.is_action_pressed("left_click") and !is_held:
		is_held = true
	elif Input.is_action_just_released("left_click"):
		if target:
			if target.is_movable():
				target = check_for_insertable_slot(target)
		is_held = false 
		target = null
	if target:
		set_target_for_movement(mouse_pos, target)

func check_for_insertable_slot(target):
	var slot = wireboard.get_wire_slot(target.position)
	if slot:
		target.z_index = 0
		target.set_destination(slot.slot_info.global_position)
		target.should_snap = false
		wireboard.insert_gate(target, target.position, slot.idx)
	else:
		target.destroy_after_movement()
	return target

func set_target_for_movement(mouse_pos, target):
	if target.is_movable():
		if is_held:
			target.should_snap = true
			target_pos = mouse_pos + offset
		if is_held and target.destination() != target_pos:
			target.set_destination(target_pos)

func set_target(target):
	if target:
		target.z_index = 1
		target = check_if_button(target)
	if target and target.logic_gate.inserted:
		wireboard.remove_gate(target.position)
	return target

func check_if_button(target):
	if target.name.find("Button") != -1:
		target = target.on_click(target.position, self)
	
	return target

func check_for_ray_target(mouse_pos):
	var target
	space_state = get_world_2d().direct_space_state
	var ray_results = space_state.intersect_point(mouse_pos)
	if ray_results: 
		for result in ray_results:
			for group in result.collider.get_groups():
				if group == "LogicGate":
						target = result.collider
			if result.collider.get_groups()[0].find("Button") != -1:
				target = result.collider
			if target:
				offset = get_offset(target.position, mouse_pos)
	return target

func get_offset(origin, target):
	var heading = origin - target
	var distance = heading.length()
	var direction = (heading / distance)
	return position + direction * distance

func _process(delta):
	check_input()
