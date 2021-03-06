extends Node2D
onready var bit = $Bit
onready var bit_value = bit.bit
var old_state
onready var wire_positions = $WireSegments.get_children()
onready var wire_gates = $WireSegments.get_children()
onready var shape = get_node("Area2D/CollisionShape2D")
onready var top_right = Vector2(shape.global_position.x + shape.shape.extents.x, shape.global_position.y + shape.shape.extents.y)
onready var bottom_right = Vector2(shape.global_position.x + shape.shape.extents.x, shape.global_position.y -shape.shape.extents.y)
onready var top_left = Vector2(shape.global_position.x -shape.shape.extents.x, shape.global_position.y + shape.shape.extents.y)
onready var output = get_node("Label")
onready var state_checker = StateChecker.new()
onready var speech = $SuspectSpeech
export (String) var other_person
var entangled = false
var idx

class SlotInfo:
	var slot_info
	var idx

func _ready():
	speech.other = other_person
	speech.change_testemony([1,0])
	old_state = [1,0]
 
func insert(gate, idx, wireboard):
	var reprocess = false
	if idx < wire_gates.size() and idx >= 0:
		var existing_value = wire_gates[idx]
		if !(existing_value is Sprite) and existing_value != self:
			destroy_gate(existing_value)
			wireboard.process_bits()
		gate.logic_gate.inserted = true
		wire_gates[idx] = gate

func destroy_gate(gate):
	var name = gate.name.split("@")
	if name.size() > 1:
		name = name[1] + "_button"
	else:
		name = name[0] + "_button"
	var btn = get_tree().get_nodes_in_group(name)
	if btn.size() > 0:
		gate.remove_from_group("LogicGate")
		gate.logic_gate.destroy = true
		gate.set_movable(false) 
		gate.set_destination(btn[0].position, false)

func remove(idx):
	var gate
	if idx < wire_gates.size() and idx >= 0:
		gate = wire_gates[idx]
		if !(gate is Sprite):
			if not gate.name.find("CNOT") == -1:
				if gate.controlling_gate and gate.control and (not gate.control == [0,1] or not gate.control == [1,0]):
					entangled = false
			elif not gate.name.find("Control") == -1:
				if gate.controlled_gate and (not gate.passed_value == [0,1] or not gate.passed_value == [1,0]):
					entangled = false
			gate.logic_gate.inserted = false
			wire_gates[idx] = wire_positions[idx]
			gate.on_removed()
			return gate

func check_in_bounds(coords): 
	var x = coords.x < top_right.x and coords.x > top_left.x  
	var y = coords.y < top_right.y and coords.y > bottom_right.y
	return x and y

func get_closest_slot(coords):
	var closest 
	var min_dist = 10000000
	var idx = 0
	for pos in wire_positions:
		var dist = (coords - pos.global_position).length()
		if  dist < min_dist:
			closest = SlotInfo.new() 
			closest.slot_info = pos
			closest.idx = idx
			min_dist = dist
		idx += 1
	return closest

func reset():
	bit_value = bit.bit

func process_bit(idx, wireboard):
	var gate = wire_gates[idx]
	var end_val = [bit_value, null]
	if not gate is Sprite:
		gate.passed_value = bit_value
		var result = gate.process_value()
		if result:
			bit_value = result[0]
			end_val[0] = bit_value
			if result[1] != null:
				result[1].entangled = true
				entangled = true
				end_val[1] = result[1]
	return end_val

func update_testemony():
	var factored = state_checker.factor_state(bit_value)
	if factored:
		factored = factored[0]
	if (not state_checker.array_eq(factored, old_state)):
		speech.change_testemony(factored)
	old_state = factored

func update_bits():
	for gate in wire_gates:
		if not gate is Sprite:
			gate.passed_value = bit_value

func update_bounds():
	top_right = Vector2(shape.global_position.x + shape.shape.extents.x, shape.global_position.y + shape.shape.extents.y)
	bottom_right = Vector2(shape.global_position.x + shape.shape.extents.x, shape.global_position.y -shape.shape.extents.y)
	top_left = Vector2(shape.global_position.x -shape.shape.extents.x, shape.global_position.y + shape.shape.extents.y)