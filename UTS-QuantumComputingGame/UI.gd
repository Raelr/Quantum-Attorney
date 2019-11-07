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
		if target != null:
			target.on_click()
	elif Input.is_action_pressed("left_click") and !is_held:
		is_held = true
	elif Input.is_action_just_released("left_click"):
		if target and target.is_movable:
			var slot = wireboard.check_wires(target.position)
			if slot:
				target_pos = slot.slot_info.global_position
				target.destination = target_pos
				target.should_snap = false
		is_held = false 
		target = null
	elif Input.is_action_just_pressed("space"):
		spawn_bit()
	
	if is_held and target: 
		target.should_snap = true
		target_pos = mouse_pos + offset
	if is_held and target and target.destination != target_pos:
		target.destination = target_pos
			
func check_for_ray_target():
	space_state = get_world_2d().direct_space_state
	var ray_results = space_state.intersect_point(mouse_pos)
	if ray_results: 
		target = ray_results[0].collider
		offset = get_offset(target.position, mouse_pos)

func spawn_bit():
	var new = preload("res://UI.tscn").instance()
	new.position = Vector2(OS.get_window_size().x * 0.5, OS.get_window_size().y * 0.5)
	add_child(new)
	new.initialise(true)

func get_offset(origin, target):
	var heading = origin - target
	var distance = heading.length()
	var direction = (heading / distance)
	return position + direction * distance

func _process(delta):
	check_input()
