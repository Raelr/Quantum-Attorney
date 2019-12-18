class_name LogicGateButton

func spawn_gate(mouse, parent, loaded_asset):
	var new = loaded_asset.instance()
	new.position = mouse
	parent.add_child(new)
	new.initialise(true)
	new.z_index = 1
	return new