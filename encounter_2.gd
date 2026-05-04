extends Control

var dialogue = [
	{"type": "desc", "text": "You are stopped by..a lobster?..a man in a lobster suit?..."},
	{"type": "npc", "text": "OI!"},
	{"type": "player", "text": "..Jesus Christ the fumes are finally getting to me.."},
	{"type": "player", "text": "Yes...?"},
	{"type": "desc", "text": "He stares at you intensely."},
	{"type": "npc", "text": "You got a problem?"},
	{"type": "npc", "text": "YOU GOT A PROBLEM!?"},
	{"type": "player", "text": "No mate no problems here...just trying to get to my front door."},
	{"type": "npc", "text": "Are you saying IM the problem!?"},
	{"type": "player", "text": "......."},
	{"type": "desc", "text": "You both stare at eachother for a moment"},
	{"type": "npc", "text": "Here hold this."},
	{"type": "desc", "text": "He hands you an empty bottle", "show_bottle": true},
	{"type": "desc", "text": "Its empty."},
	{"type": "player", "text": "uh...thanks...listen im just trying to get home..can i go now?"},
	{"type": "npc", "text": "Why"},
	{"type": "player", "text": "Because I live here?"},
	{"type": "npc", "text": "Not good enough."},
	{"type": "desc", "text": "He takes the empty bottle back."},
	{"type": "npc", "text": "You failed the test."},
	{"type": "desc", "text": "He walks away sideways like a crab."},
	{"type": "player", "text": "...what test?"}
]

var dialogue_index = 0
var is_typing = false
var full_text = ""
var current_text = ""
var current_color = "white"
var typing_speed = 0.03
var npc_has_left = false

@export var eyes_open: Texture2D
@export var eyes_closed: Texture2D

@onready var portrait = $TextureRect
@onready var blink_timer = $TextureRect/Timer
@onready var bottle_image = $BottleImage

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	$DialogueBox.visible = true
	$hint.visible = false
	bottle_image.visible = false

	if eyes_open:
		portrait.texture = eyes_open

	blink_timer.wait_time = randf_range(1.5, 4.0)
	blink_timer.start()

	show_dialogue_line()

func show_dialogue_line():
	var line = dialogue[dialogue_index]

	match line["type"]:
		"desc":
			current_color = "white"
		"player":
			current_color = "#4a9eff"
		"npc":
			current_color = "red"

	full_text = line["text"]
	current_text = ""
	is_typing = true

	$DialogueBox/DialogueLabel.clear()
	$hint.visible = false
	$hint.text = "[Space / Click to continue]"

	if line.has("show_bottle") and line["show_bottle"]:
		show_bottle()
	else:
		hide_bottle()

	if npc_has_left:
		portrait.visible = false
		bottle_image.visible = false

	if has_node("dialogue_sound"):
		$dialogue_sound.stop()
		$dialogue_sound.play()

	if line["text"] == "He walks away sideways like a crab.":
		walk_away()

	type_text()

func show_bottle():
	if npc_has_left:
		bottle_image.visible = false
		portrait.visible = false
		return

	bottle_image.visible = true
	portrait.visible = false

func hide_bottle():
	if npc_has_left:
		bottle_image.visible = false
		portrait.visible = false
		return

	bottle_image.visible = false
	portrait.visible = true

func type_text():
	for i in range(full_text.length()):
		if !is_typing:
			if has_node("dialogue_sound"):
				$dialogue_sound.stop()
			return

		current_text += full_text[i]
		$DialogueBox/DialogueLabel.clear()
		$DialogueBox/DialogueLabel.append_text("[color=%s]%s[/color]" % [current_color, current_text])

		await get_tree().create_timer(typing_speed).timeout

	is_typing = false
	$hint.visible = true

	if has_node("dialogue_sound"):
		$dialogue_sound.stop()

func walk_away():
	if not portrait.visible:
		return

	npc_has_left = true

	var start_pos = portrait.position
	var tween = create_tween()

	tween.parallel().tween_property(
		portrait,
		"position:x",
		start_pos.x + 400,
		1.2
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

	tween.parallel().tween_property(
		portrait,
		"position:y",
		start_pos.y - 10,
		0.2
	)
	tween.parallel().tween_property(
		portrait,
		"position:y",
		start_pos.y + 10,
		0.2
	).set_delay(0.2)
	tween.parallel().tween_property(
		portrait,
		"position:y",
		start_pos.y - 10,
		0.2
	).set_delay(0.4)
	tween.parallel().tween_property(
		portrait,
		"position:y",
		start_pos.y + 10,
		0.2
	).set_delay(0.6)
	tween.parallel().tween_property(
		portrait,
		"position:y",
		start_pos.y - 10,
		0.2
	).set_delay(0.8)
	tween.parallel().tween_property(
		portrait,
		"position:y",
		start_pos.y,
		0.2
	).set_delay(1.0)

	tween.tween_callback(func():
		portrait.visible = false
		bottle_image.visible = false
	)

func advance_dialogue():
	dialogue_index += 1

	if dialogue_index < dialogue.size():
		show_dialogue_line()
	else:
		if has_node("dialogue_sound"):
			$dialogue_sound.stop()

		GlobalData.returning_from_encounter = true
		SceneTransition.change_scene("res://mainfinal.tscn")

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

		if has_node("dialogue_sound"):
			$dialogue_sound.stop()
	else:
		advance_dialogue()

func _on_timer_timeout():
	blink()

func blink():
	if not eyes_open or not eyes_closed or not portrait.visible:
		return

	portrait.texture = eyes_closed
	await get_tree().create_timer(0.1).timeout
	portrait.texture = eyes_open

	blink_timer.wait_time = randf_range(1.5, 4.0)
	blink_timer.start()
