extends KinematicBody2D
var bit
var label
var should_snap
onready var logic_gate = LogicGate.new()

func _ready():
	initialise(false)

func on_removed():
	pass

func on_insert(wireboard, wire, slot):
	pass

func set_bit(value):
	bit = value
	logic_gate.update_text(bit[1], label)

# REUSABLE FUNCTIONS, DO NOT REMOVE 
func initialise(status):
	bit = [1,0]
	label = $Label
	logic_gate.update_text(bit[1], label)
	set_movable(status)

func destroy_after_movement():
	should_snap = false
	logic_gate.destroy = true
	set_movable(false)
	remove_from_group("LogicGate")
	logic_gate.destination = get_tree().get_nodes_in_group("bitButton")[0].position

func set_movable(status):
	logic_gate.is_movable = status

func is_movable():
	return logic_gate.is_movable

func set_destination(destination, snap):
	logic_gate.destination = destination
	should_snap = snap

func destination():
	return logic_gate.destination
	
func will_be_destroyed():
	return logic_gate.destroy

func _process(delta):
	logic_gate.process_movement(delta, should_snap, self)