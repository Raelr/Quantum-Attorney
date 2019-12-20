extends Sprite

onready var animation = $AnimationPlayer
var start
var quit
var destination : Vector2
onready var despawn = get_parent().get_node("MenuSpawn").global_position
var should_despawn = false
var utils = preload("res://Scripts/Util.gd")

func _ready():
	start = get_node("StartButton")
	quit = get_node("QuitButton")
	start.spawn = get_parent().get_node("GameSpawn").global_position

func on_hover_start():	
	if not animation.current_animation == "START_idle":
		animation.current_animation = "START_idle"

func on_hover_quit():
	if not animation.current_animation == "QUIT":
		animation.current_animation = "QUIT"

func on_empty():
	if not animation.current_animation == "Idle":
		animation.current_animation = "Idle"

func _physics_process(delta):
	if should_despawn:
		if utils.get_distance(position, despawn) > 0.01:
			position = position.linear_interpolate(despawn, delta * 5)
		else:
			position = despawn
			set_process(false)