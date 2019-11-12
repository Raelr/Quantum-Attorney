extends KinematicBody2D
onready var line = get_node("ControlLine")
var should_snap
onready var logic_gate = LogicGate.new()

func on_insert(wireboard, wire, slot):
	line.add_point(Vector2(0,0))
	line.set_process(true)
	if wire.idx > 0 and wire.idx < wireboard.wires.size():
		var new_idx = wire.idx - 1
		var control_wire = wireboard.wires[new_idx]
		if control_wire:
			line.destination = (control_wire.wire_positions[slot.idx].global_position - slot.slot_info.global_position)
			var gate = control_wire.wire_gates[slot.idx]
			if gate.name.find("CNOT") != -1:
				gate.control = wire.bit.bit
				print(gate.control)

func on_removed():
	line.remove_point(1)
	line.set_process(false)

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