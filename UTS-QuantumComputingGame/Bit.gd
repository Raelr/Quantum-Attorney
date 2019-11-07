extends KinematicBody2D

export (bool) var bit
var label
var is_movable
export (int) var speed = 500
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

func _process(delta):
	logic_gate.process_movement(delta, should_snap, destination, self)
	