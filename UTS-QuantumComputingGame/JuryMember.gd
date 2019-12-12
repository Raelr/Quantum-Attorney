extends Sprite

var color = Color()
export (float) var duration
onready var elapsed = 0.0
var change = false

func change_color(new):
	color = new
	change = true

func _physics_process(_delta):
	if change:
		if elapsed < duration:
			elapsed += _delta
			modulate = modulate.linear_interpolate(color, _delta * 3)
		elif elapsed >= duration:
			modulate = color
			elapsed = 0.0
			change = false