extends KinematicBody2D

var load_asset = preload("res://Game.tscn")
var spawn
onready var clicked = false

func on_click():
	if not clicked:
		var new = load_asset.instance()
		new.position = spawn
		get_parent().get_parent().add_child(new)
		get_parent().should_despawn = true