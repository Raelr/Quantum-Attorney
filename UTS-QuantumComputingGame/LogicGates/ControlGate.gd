extends KinematicBody2D
onready var line = get_node("ControlLine")
var should_snap
onready var logic_gate = LogicGate.new()
var controlled_gate
var passed_value

func process_value():
	if controlled_gate:
		controlled_gate.control = passed_value

func on_insert(wireboard, wire, slot):
	if wire.idx >= 0 and wire.idx < wireboard.wires.size():
		var new_idx = wire.idx + 1
		var control_wire = wireboard.wires[new_idx]
		if control_wire:
			var gate = control_wire.wire_gates[slot.idx]
			if gate.name.find("CNOT") != -1:
				attach_gate(gate, wireboard, wire)

func attach_gate(other_gate, wireboard, wire):
	controlled_gate = other_gate
	line.add_point(Vector2(0,0))
	line.set_process(true)
	var slot = wireboard.get_wire_slot(other_gate.position)
	line.destination = (slot.slot_info.global_position - wire.wire_positions[slot.idx].global_position)
	controlled_gate.control = passed_value
	controlled_gate.controlling_gate = self
	#wire.process_bits(wireboard)

func on_removed():
	
	line.remove_point(1)
	line.set_process(false)
	if controlled_gate:
		controlled_gate.control = null
		controlled_gate.controlling_gate = null
		controlled_gate = null

func _ready():
	initialise(true)

func initialise(status):
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