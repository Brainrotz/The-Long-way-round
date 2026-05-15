extends Control

@export var scroll_speed: float = 45.0
@export var return_scene: String = "res://start_menu.tscn"

@onready var credits_text = $CreditsText

var finished = false

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	if credits_text is RichTextLabel:
		credits_text.bbcode_enabled = true
		credits_text.text = """
[center][font_size=36]The Long Way Round[/font_size]

[font_size=22]Created by[/font_size]
Cristina Bianchi


[font_size=22]Game Design[/font_size]
Cristina Bianchi

[font_size=22]Writing[/font_size]
Cristina Bianchi

[font_size=22]Programming[/font_size]
Cristina Bianchi

[font_size=22]Art and Visual Design[/font_size]
Cristina Bianchi
Calix Borrero Diaz 

[font_size=22]Sound Design[/font_size]
Cristina Bianchi


Made with Godot Engine


[font_size=22]Special Thanks[/font_size]
Tutors, playtesters, friends and family


Thank you for playing[/center]
"""
	else:
		credits_text.text = "The Long Way Round\n\nCreated by\nCristina Bianchi\n\nThank you for playing"

	credits_text.position.y = get_viewport_rect().size.y + 50

func _process(delta):
	if finished:
		return

	credits_text.position.y -= scroll_speed * delta

	if credits_text.position.y + credits_text.size.y < -50:
		finish_credits()

func _input(event):
	if event.is_action_pressed("ui_accept") or (event is InputEventMouseButton and event.pressed):
		finish_credits()

func finish_credits():
	if finished:
		return

	finished = true
	SceneTransition.change_scene(return_scene)
