extends Node2D
const util = preload("Util.gd")
onready var wireboard = get_node("/root/Node2D/WireBoard")
onready var raycast = RayCastController.new()
onready var main = get_tree().get_nodes_in_group("MainMenu")[0]
var jury 
var target
var previous_target
var is_held : bool
var offset = Vector2()

func check_input(delta):
	var mouse_pos = get_global_mouse_position()
	var moused_over = raycast.raycast_for_groups(self, mouse_pos, ["LogicGate", "button"])
	if moused_over:
		if moused_over.name.find("Button") != -1:
			if moused_over.name.find("Start") != -1:
				main.on_hover_start()
			elif moused_over.name.find("Quit") != -1:
				main.on_hover_quit()
	else:
		main.on_empty()	

	if Input.is_action_just_pressed("left_click"):
		target = set_target(moused_over)
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
		if target.name.find("Start") != -1 or target.name.find("Quit") != -1:
			target.on_click()
			target = null
		else: 
			target = target.on_click(target.global_position, self)
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