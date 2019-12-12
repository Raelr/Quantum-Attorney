extends Sprite

var verdicts = Array() 
var used_verdicts = Array()
onready var jurors = get_tree().get_nodes_in_group("Juror")
export (Array) var groups

func setup():
	verdicts = get_tree().get_nodes_in_group("Speech")

func reset():
	for verdict in used_verdicts:
		verdict.reset()
	used_verdicts.clear()

func activate_next(values):
	for verdict in verdicts:
		if not is_active(verdict):
			verdict.set_verdict(values)
			used_verdicts.append(verdict)
			change_colors()
			return

func change_colors():
	if used_verdicts.size() == 1:
		for juror in jurors:
			juror.modulate = groups[0]
	elif used_verdicts.size() == 2:
		for i in range(0, jurors.size()):
			if i >= ((jurors.size() / 2)):
				jurors[i].modulate = groups[1]
			else:
				jurors[i].modulate = groups[0]
	elif used_verdicts.size() == 4:
		jurors[0].modulate = groups[0]
		jurors[1].modulate = groups[0]
		jurors[2].modulate = groups[1]
		jurors[3].modulate = groups[1]
		jurors[4].modulate = groups[2]
		jurors[5].modulate = groups[2]
		jurors[6].modulate = groups[3]
		jurors[7].modulate = groups[3]

func is_active(speech):
	return used_verdicts.has(speech)