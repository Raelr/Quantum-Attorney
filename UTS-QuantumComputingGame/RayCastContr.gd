class_name RayCastController

func raycast_for_groups(root, pos, groups):
	var target
	var ray_results = root.get_world_2d().direct_space_state.intersect_point(pos)
	if ray_results: 
		for results in ray_results:
			print(results.collider.get_groups())
			for group in results.collider.get_groups():
				if group == groups[0] or group.find(groups[1]) != -1:
					target = results.collider
	print(target)
	return target