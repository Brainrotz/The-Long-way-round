extends Control

var dialogue = [
	"WOW What a long day of work...Im so excited to just lay down and forget about it.......",
	"Ah im at the wrong entrance.",
	"Its not that big of a deal right? I mean I still live here...",
	"Well im already here.."
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
			return
		
		current_text += full_text[i]
		$DialogueBox/DialogueLabel.text = current_text
		await get_tree().create_timer(typing_speed).timeout
	
	is_typing = false
	$hint.visible = true   

func _input(event):
	if event.is_action_pressed("ui_accept") or (event is InputEventMouseButton and event.pressed):
		if is_typing:
			is_typing = false
			$DialogueBox/DialogueLabel.text = full_text
		else:
			next_line()

func next_line():
	dialogue_index += 1
	
	if dialogue_index < dialogue.size():
		show_line(dialogue[dialogue_index])
	else:
		SceneTransition.change_scene("res://office_scene.tscn")
