static func get_offset(origin, target, position):
	var heading = origin - target
	var distance = heading.length()
	var direction = (heading / distance)
	return position + direction * distance

static func get_distance(origin, destination):
	var heading = destination - origin
	return heading.length()