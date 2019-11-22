extends KinematicBody2D
onready var logic_gate = LogicGate.new()
onready var maths = MathUtils.new()
var transform_mat
var should_snap
var passed_value
var processed

func _ready():
	initialise(true)

func on_insert(wireboard, wire, slo):
	pass

func on_removed():
	pass

func process_value():
	if passed_value:
		var result = transform_mat.get_product(transform_mat, passed_value)
		processed = true
		return result

func initialise(status):
	var row_1 = [1/sqrt(2), 1/sqrt(2)]
	var row_2 = [1/sqrt(2), (-1)/sqrt(2)]
	transform_mat = maths.create_mat4([row_1, row_2])
	
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