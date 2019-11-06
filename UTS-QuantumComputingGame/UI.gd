extends Node2D

export (int) var speed = 200
var velocity := Vector2()
var target
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
		wireboard.check_wires(mouse_pos)
	elif Input.is_action_just_released("left_click"):
		is_held = false 
		target = null
	elif Input.is_action_just_pressed("space"):
		spawn_bit()
	
			
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

func _physics_process(delta):
	check_input()
	if target != null and is_held and target.is_movable:
		target.position = mouse_pos + offset
