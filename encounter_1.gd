extends Control

enum GameState {
	VN_INTRO,
	VN_OUTRO
}

var state = GameState.VN_INTRO

var intro_dialogue = [
	{"type": "desc", "text": "You meet a strange figure."},
	{"type": "npc", "text": "Excuse me excuse me can I have a moment of your time"},
	{"type": "player", "text": "Oh you have got to be joking, I'm not even near the station"},
	{"type": "player", "text": "Sorry mate, I'm in a rush-"},
	{"type": "desc", "text": "They pull out a deck of cards."},
	{"type": "npc", "text": "Let's play a simple game."},
	{"type": "npc", "text": "Higher or lower."},
	{"type": "npc", "text": "If you win, I'll leave you alone."},
	{"type": "npc", "text": "If you lose you have to donate."},
	{"type": "player", "text": "Mate what-"}
]

var outro_dialogue = [
	{"type": "npc", "text": "Three losses in a row is just peak."},
	{"type": "npc", "text": "Oh...your card declined."},
	{"type": "player", "text": "Bro how did you get my card???."},
	{"type": "npc", "text": "Dont worry about it."},
	{"type": "desc", "text": "He turns around and runs off."}
]

var dialogue_index = 0
var current_dialogue = []

var is_typing = false
var full_text = ""
var current_text = ""
var current_color = "white"
var typing_speed = 0.03

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	$DialogueBox.visible = true
	$hint.visible = false

	if GlobalData.from_card_game:
		GlobalData.from_card_game = false
		start_vn(outro_dialogue, GameState.VN_OUTRO)
	else:
		start_vn(intro_dialogue, GameState.VN_INTRO)

func start_vn(dialogue_lines: Array, new_state):
	state = new_state
	current_dialogue = dialogue_lines
	dialogue_index = 0

	$DialogueBox.visible = true
	$hint.visible = false

	show_dialogue_line()

func show_dialogue_line():
	var line = current_dialogue[dialogue_index]

	match line["type"]:
		"desc":
			current_color = "white"
		"player":
			current_color = "blue"
		"npc":
			current_color = "green"

	full_text = line["text"]
	current_text = ""
	is_typing = true

	$DialogueBox/DialogueLabel.clear()
	$hint.visible = false
	$hint.text = "[Space / Click to continue]"

	if has_node("dialogue_sound"):
		$dialogue_sound.play()

	type_text()

func type_text():
	for i in range(full_text.length()):
		if !is_typing:
			return

		current_text += full_text[i]
		$DialogueBox/DialogueLabel.clear()
		$DialogueBox/DialogueLabel.append_text("[color=%s]%s[/color]" % [current_color, current_text])

		await get_tree().create_timer(typing_speed).timeout

	is_typing = false
	$hint.visible = true

func advance_dialogue():
	dialogue_index += 1

	if dialogue_index < current_dialogue.size():
		show_dialogue_line()
	else:
		if state == GameState.VN_INTRO:
			SceneTransition.change_scene("res://card_game.tscn")
		elif state == GameState.VN_OUTRO:
			SceneTransition.change_scene("res://main.tscn")

func _unhandled_input(event):
	var pressed_continue = event.is_action_pressed("ui_accept") or (
		event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT
	)

	if not pressed_continue:
		return

	if is_typing:
		is_typing = false
		$DialogueBox/DialogueLabel.clear()
		$DialogueBox/DialogueLabel.append_text("[color=%s]%s[/color]" % [current_color, full_text])
		$hint.visible = true
	else:
		advance_dialogue()
