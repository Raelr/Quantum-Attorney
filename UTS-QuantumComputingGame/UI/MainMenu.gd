extends Sprite

onready var animation = $AnimationPlayer

func on_hover_start():	
	if not animation.current_animation == "START_idle":
		animation.current_animation = "START_idle"

func on_hover_quit():
	if not animation.current_animation == "QUIT":
		animation.current_animation = "QUIT"

func on_empty():
	if not animation.current_animation == "Idle":
		animation.current_animation = "Idle"