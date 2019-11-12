extends Line2D
const utils = preload("Util.gd")
var destination
var speed = 8
	
func set_line_extents(destination):
	set_point_position(1, destination)

func _process(delta):
	if destination:
		if utils.get_distance(get_point_position(1), destination) > 0.01:
			set_line_extents(
			get_point_position(1).linear_interpolate(destination, delta * speed))
