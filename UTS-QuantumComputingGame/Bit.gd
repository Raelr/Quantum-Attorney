extends KinematicBody2D

var bit
var label
var is_movable
var speed = 500
var destination
var should_snap
onready var logic_gate = LogicGate.new()

func _ready():
	bit = 0
	label = $Label
	logic_gate.update_text(bit, label)
	is_movable = false

func initialise(status):
	bit = 0
	label = $Label
	logic_gate.update_text(bit, label)
	is_movable = status

func on_click(): 
	if bit == 0:
		bit = 1
	elif bit == 1:
		bit = 0
	logic_gate.update_text(bit, label)

func _process(delta):
	logic_gate.process_movement(delta, should_snap, destination, self)
	