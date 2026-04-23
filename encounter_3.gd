extends Control

var dialogue = [
	{"type": "desc", "text": "A woman steps into your way before you can reach the entrance."},
	{"type": "npc", "text": "You got a light?"},
	{"type": "player", "text": "No, sorry."},
	{"type": "npc", "text": "You sure?"},
	{"type": "player", "text": "Pretty sure, yeah."},
	{"type": "desc", "text": "She squints at you like that was the wrong answer."},
	{"type": "npc", "text": "Then look at this."},
	{"type": "desc", "text": "She holds up her pack of cigarettes.", "show_cigs": true},
	{"type": "npc", "text": "Thats my Alfie on the front."},
	{"type": "npc", "text": "Proper model innit."},
	{"type": "player", "text": "...right."},
	{"type": "npc", "text": "Anyway."},
	{"type": "desc", "text": "She pockets the pack and wanders off."},
	{"type": "player", "text": "What was that even about?"}
]

var dialogue_index = 0
var is_typing = false
var full_text = ""
var current_text = ""
var current_color = "white"
var typing_speed = 0.03

@onready var npc_sprite = $npc
@onready var cigs_image = $TextureRect

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	$DialogueBox.visible = true
	$hint.visible = false
	cigs_image.visible = false
	npc_sprite.visible = true

	if $DialogueBox/DialogueLabel is RichTextLabel:
		$DialogueBox/DialogueLabel.bbcode_enabled = true

	show_dialogue_line()

func show_dialogue_line():
	var line = dialogue[dialogue_index]

	match line["type"]:
		"desc":
			current_color = "white"
		"player":
			current_color = "#4a9eff"
		"npc":
			current_color = "purple"

	full_text = line["text"]
	current_text = ""
	is_typing = true

	$DialogueBox/DialogueLabel.clear()
	$hint.visible = false
	$hint.text = "[Space / Click to continue]"

	if line.has("show_cigs") and line["show_cigs"]:
		show_cigs()
	else:
		hide_cigs()

	if has_node("dialogue_sound"):
		$dialogue_sound.stop()
		$dialogue_sound.play()

	type_text()

func show_cigs():
	cigs_image.visible = true
	npc_sprite.visible = false

func hide_cigs():
	cigs_image.visible = false
	npc_sprite.visible = true

func set_dialogue_text(text_to_show: String):
	$DialogueBox/DialogueLabel.clear()
	$DialogueBox/DialogueLabel.append_text(
		"[color=%s]%s[/color]" % [current_color, text_to_show]
	)

func type_text():
	for i in range(full_text.length()):
		if !is_typing:
			if has_node("dialogue_sound"):
				$dialogue_sound.stop()
			return

		current_text += full_text[i]
		set_dialogue_text(current_text)

		await get_tree().create_timer(typing_speed).timeout

	is_typing = false
	$hint.visible = true

	if has_node("dialogue_sound"):
		$dialogue_sound.stop()

func advance_dialogue():
	dialogue_index += 1

	if dialogue_index < dialogue.size():
		show_dialogue_line()
	else:
		if has_node("dialogue_sound"):
			$dialogue_sound.stop()
		SceneTransition.change_scene("res://main.tscn")

func _unhandled_input(event):
	var pressed_continue = event.is_action_pressed("ui_accept") or (
		event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT
	)

	if not pressed_continue:
		return

	if is_typing:
		is_typing = false
		set_dialogue_text(full_text)
		$hint.visible = true

		if has_node("dialogue_sound"):
			$dialogue_sound.stop()
	else:
		advance_dialogue()
