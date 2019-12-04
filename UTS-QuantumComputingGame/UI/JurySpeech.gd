extends Node2D
const utils = preload("res://Scripts/Util.gd")
onready var verdicts = [$Sprite/PersonAVerdict, $Sprite/PersonBVerdict]
export (Array) var colors
onready var animator = $AnimationPlayer

func set_verdict(values):
	if animator.current_animation == "rest":
		animator.queue("shrink")
	
	for i in range(0, values.size()):
		var verdict = verdicts[i]
		if values[i] == 0:
			verdict.modulate = colors[0]
			verdict.text = "Innocent"
		else:
			verdict.modulate = colors[1]
			verdict.text = "Guilty"
	
	animator.queue("enlarge")
	animator.queue("free")	

func reset():
	animator.queue("shrink")