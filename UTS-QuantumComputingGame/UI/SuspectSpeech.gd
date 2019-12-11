extends Sprite
export (String) var other
export (float) var scrollDuration
var elapsed = 0.0
onready var center = $Center
onready var top = $Top
onready var bottom = $Bottom
onready var state_checker = StateChecker.new()
onready var update_texts = Array()

func change_testemony(state):
	center.percent_visible = 0
	top.percent_visible = 0
	bottom.percent_visible = 0
	if not state:
		top.text = "I may have done it!"
		bottom.text = other + " was there with me!"
		update_texts.append(top)
		update_texts.append(bottom)
	else:
		if state_checker.array_eq(state, [1/sqrt(2), 1/sqrt(2)]):
			center.text = "I may have done it!"
		else:
			if state_checker.compare(state[0], 1):
				center.text = "I didn't do it!"
			elif state_checker.compare(state[0], 0):
				center.text = "I did it!"
		update_texts.append(center)

func _physics_process(_delta):
	if update_texts.size() > 0:
			elapsed += _delta
			if not elapsed >= scrollDuration:
				var percentage = elapsed / scrollDuration
				for text in update_texts:
					text.percent_visible = percentage
			else:
				for text in update_texts:
					text.percent_visible = 1
					update_texts.clear()
					elapsed = 0