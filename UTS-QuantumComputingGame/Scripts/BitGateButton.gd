extends KinematicBody2D

onready var button = LogicGateButton.new()
var loaded_asset = preload("res://LogicGates/Bit.tscn")

func on_click(mouse_pos, parent):
	z_index = 1
	var gate = button.spawn_gate(mouse_pos, parent, loaded_asset)
	return gate