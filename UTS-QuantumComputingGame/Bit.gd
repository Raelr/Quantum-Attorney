extends KinematicBody2D

var bit
var label
var is_movable
var speed = 500
var destination
var should_snap

func _ready():
	bit = 0
	label = $Label
	update_text(bit)
	is_movable = false

func initialise(status):
	bit = 0
	label = $Label
	update_text(bit)
	is_movable = status

func on_click(): 
	if bit == 0:
		bit = 1
	elif bit == 1:
		bit = 0
	update_text(bit)

func update_text(value):
	label.text = str(value)

func get_distance_to_destination():
	var heading = destination - position
	return heading.length()
	
func _physics_process(delta):
	
	if destination and !should_snap:
		if get_distance_to_destination() > 0.01:
			position = position.linear_interpolate(destination, delta * 10)
		else:
			position = destination
			destination = null
	elif destination and should_snap:
		position = destination