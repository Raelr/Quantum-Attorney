extends Sprite

export (String) var other
onready var center = $Center
onready var top = $Top
onready var bottom = $Bottom
onready var state_checker = StateChecker.new()

func change_testemony(state):
	center.percent_visible = 0
	top.percent_visible = 0
	bottom.percent_visible = 0
	if not state:
		top.text = "I may have done it!"
		top.percent_visible = 1
		bottom.text = other + " was there with me!"
		bottom.percent_visible = 1
	else:
		state = state[0]
		if state_checker.array_eq(state, [1/sqrt(2), 1/sqrt(2)]):
			center.text = "I may have done it!"
		else:
			if state_checker.compare(state[0], 1):
				center.text = "I didn't do it!"
			elif state_checker.compare(state[0], 0):
				center.text = "I did it!"
		center.percent_visible = 1