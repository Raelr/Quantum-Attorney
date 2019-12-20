extends Node2D

var move = false
var utils = preload("Scripts/Util.gd")

func _ready():
	get_tree().get_root().get_node("/root/UIController").wireboard = get_node("WireBoard")
	move = true

func _physics_process(delta):
	if move:
		if utils.get_distance(position, Vector2(0, 73.818)) > 0.1:
			position = position.linear_interpolate(Vector2(0, 73.818), delta * 5)
		else:
			position = Vector2(0, 73.818)
			get_node("WireBoard").update_bounds()
			move = false