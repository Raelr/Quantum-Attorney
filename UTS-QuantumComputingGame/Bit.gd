extends KinematicBody2D

export (bool) var bit
var label
export (int) var speed = 500
var should_snap

onready var logic_gate = LogicGate.new()

func _ready():
	bit = 0
	label = $Label
	logic_gate.update_text(bit, label)
	set_movable(false)

func initialise(status):
	bit = 0
	label = $Label
	logic_gate.update_text(bit, label)
	set_movable(status)

func destroy_after_movement():
	should_snap = false
	logic_gate.destroy = true
	set_movable(false)
	remove_from_group("LogicGate")
	logic_gate.destination = get_tree().get_nodes_in_group("bitButton")[0].position

# REUSABLE FUNCTIONS, DO NOT REMOVE 
func set_movable(status):
	logic_gate.is_movable = status

func is_movable():
	return logic_gate.is_movable

func set_destination(destination):
	logic_gate.destination = destination

func set_selected(pos):
	pass

func destination():
	return logic_gate.destination
	
func will_be_destroyed():
	return logic_gate.destroy

func _process(delta):
	logic_gate.process_movement(delta, should_snap, self)
	