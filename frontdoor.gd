extends Control

var dialogue = [
	"My knees.",
	"Oh great...more undisclosed bills for me to pay.",
	"What will it take for them to fix the damp and mold issues in this part of the apartment.",
	"I heard they built a new rooftop bar.",
	"Meanwhile this corridor smells like a wet towel.",
	"Suppose we're not the target audience, are we?",
	"Oh for fuck sake i forgot to buy milk...",
	"Time to do this all over again."
]

var dialogue_index = 0
var is_typing = false
var full_text = ""
var current_text = ""
var typing_speed = 0.03

func _ready():
	start_dialogue()

func start_dialogue():
	dialogue_index = 0
	show_line(dialogue[dialogue_index])

func show_line(text):
	full_text = text
	current_text = ""
	is_typing = true
	$DialogueBox/DialogueLabel.text = ""
	$hint.visible = false
	$dialogue_sound.play()
	type_text()

func type_text():
	for i in range(full_text.length()):
		if !is_typing:
			$dialogue_sound.stop()
			return
		
		current_text += full_text[i]
		$DialogueBox/DialogueLabel.text = current_text
		await get_tree().create_timer(typing_speed).timeout
	
	is_typing = false
	$hint.visible = true
	$dialogue_sound.stop()

func _input(event):
	if event.is_action_pressed("ui_accept") or (event is InputEventMouseButton and event.pressed):
		if is_typing:
			is_typing = false
			$DialogueBox/DialogueLabel.text = full_text
			$dialogue_sound.stop()
			$hint.visible = true
		else:
			next_line()

func next_line():
	dialogue_index += 1
	
	if dialogue_index < dialogue.size():
		show_line(dialogue[dialogue_index])
	else:
		$dialogue_sound.stop()
		GlobalData.easy_mode_unlocked = true
		SceneTransition.change_scene("res://start_menu.tscn")
