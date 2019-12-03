extends Node2D
const utils = preload("res://Scripts/Util.gd")
onready var verdicts = [$PersonAVerdict, $PersonBVerdict]
export (Array) var colors
onready var animator = $AnimationPlayer

enum State {ENLARGE, SHRINK, IDLE}

onready var current_state = State.ENLARGE

func set_verdict(values):
	for i in range(0, values.size()):
		var verdict = verdicts[i]
		if values[i] == 1:
			verdict.modulate = colors[0]
			verdict.text = "Innocent"
		else:
			verdict.modulate = colors[1]
			verdict.text = "Guilty"

func _ready():
	animator.play("enlarge")