extends Node2D

var target
var target_pos
var space_state; 
var is_held : bool
var mouse_pos
var offset : Vector2
onready var wireboard = get_node("/root/Node2D/WireBoard")

func check_input():
	mouse_pos = get_global_mouse_position()
	if Input.is_action_just_pressed("left_click"):
		check_for_ray_target()
		if target:
			target.z_index = 1
			if target.name.find("Button") != -1:
				target = target.on_click(target.position, self)
			elif not target.is_movable:
				target = null
				return
			if target.logic_gate.inserted:
				wireboard.remove_gate(target.position)

	elif Input.is_action_pressed("left_click") and !is_held:
		is_held = true
	elif Input.is_action_just_released("left_click"):
		if target and target.is_movable:
			var wire = wireboard.get_wire(target.position)
			var slot = wireboard.get_wire_info(wire, target.position)
			if slot:
				print(slot)
				target_pos = slot.slot_info.global_position
				target.z_index = 0
				target.destination = target_pos
				target.should_snap = false
				wireboard.insert_gate(target, target.position, slot.idx)
			else:
				target.should_snap = false
				target.logic_gate.destroy = true
				target.is_movable = false
				target.destination = get_tree().get_nodes_in_group("bitButton")[0].position
		is_held = false 
		target = null
	if target and target.is_movable:
		if is_held:
			target.should_snap = true
			target_pos = mouse_pos + offset
		if is_held and target.destination != target_pos:
			target.destination = target_pos

func check_for_ray_target():
	space_state = get_world_2d().direct_space_state
	var ray_results = space_state.intersect_point(mouse_pos)
	if ray_results: 
		target = ray_results[0].collider
		offset = get_offset(target.position, mouse_pos)

func get_offset(origin, target):
	var heading = origin - target
	var distance = heading.length()
	var direction = (heading / distance)
	return position + direction * distance

func _process(delta):
	check_input()
