extends Node
onready var logic_gate = LogicGate.new()
onready var maths = MathUtils.new()
var cnot_matrix
var pauli_x
var should_snap
var control
var controlling_gate
var passed_value

func on_removed():
	if controlling_gate:
		controlling_gate.on_removed()
		controlling_gate = null

func on_insert(wireboard, wire, slot):
	if wire.idx > 0:
		var other_wire = wireboard.wires[wire.idx - 1]
		if other_wire:
			var other = other_wire.wire_gates[slot.idx]
			for group in other.get_groups():
				if group == "Control":
					other.attach_gate(self, wireboard, other_wire)

func process_value():
	var bit_vec
	if control:
		print("Control: ", control)
		var tensor = maths.tensor([controlling_gate.passed_value, passed_value])
		print("Tensor: ", tensor)
		bit_vec = cnot_matrix.get_product(cnot_matrix, tensor)
	else:
		if passed_value.size() != pauli_x.matrix.size():
			var kron = maths.kronecker(maths.create_mat4([[1,0], [0,1]]), pauli_x)
			bit_vec = kron.get_product(kron, passed_value)
		else:
			bit_vec = pauli_x.get_product(pauli_x, passed_value)
	print("Flipped value: ", bit_vec)
	return bit_vec

func _ready():
	initialise(true)

# TODO Abstract all of these methods into an all encompassing class group. 
func initialise(status):
	var row_1 = [1, 0, 0, 0]
	cnot_matrix = maths.create_mat4([[1, 0, 0, 0], [0, 1, 0, 0], [0, 0, 0, 1], [0, 0, 1, 0]])
	pauli_x = maths.create_mat4([[0,1],[1,0]])
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