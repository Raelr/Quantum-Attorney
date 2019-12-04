extends Sprite

var verdicts = Array() 
var used_verdicts = Array()

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
			return

func is_active(speech):
	var success = false
	for verdict in used_verdicts:
		if verdict == speech:
			success = true
	return success