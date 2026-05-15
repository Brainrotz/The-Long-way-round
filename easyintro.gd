extends Control

var dialogue = [
	"WOW What a long day of work...Im so excited to just lay down and forget about it.......",
	"Finally at the entrance!",
	"I hope its the friendly concierge today"
]

var dialogue_index = 0
var is_typing = false
var full_text = ""
var current_text = ""
var typing_speed = 0.03

@onready var dialogue_label = $DialogueBox/DialogueLabel
@onready var hint = $hint
@onready var dialogue_sound = $dialogue_sound

func _ready():
	hint.visible = false
	start_dialogue()

func start_dialogue():
	dialogue_index = 0
	show_line(dialogue[dialogue_index])

func show_line(text):
	full_text = text
	current_text = ""
	is_typing = true

	dialogue_label.text = ""
	hint.visible = false

	dialogue_sound.stop()
	dialogue_sound.play()

	type_text()

func type_text():
	for i in range(full_text.length()):
		if !is_typing:
			dialogue_sound.stop()
			return

		current_text += full_text[i]
		dialogue_label.text = current_text

		await get_tree().create_timer(typing_speed).timeout

	is_typing = false
	hint.visible = true
	dialogue_sound.stop()

func _input(event):
	if event.is_action_pressed("ui_accept") or (event is InputEventMouseButton and event.pressed):
		if is_typing:
			is_typing = false
			dialogue_label.text = full_text
			dialogue_sound.stop()
			hint.visible = true
		else:
			next_line()

func next_line():
	dialogue_index += 1

	if dialogue_index < dialogue.size():
		show_line(dialogue[dialogue_index])
	else:
		dialogue_sound.stop()
		SceneTransition.change_scene("res://easyoffice.tscn")
