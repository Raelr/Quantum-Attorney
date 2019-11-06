extends KinematicBody2D

var bit
var label
var is_movable

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