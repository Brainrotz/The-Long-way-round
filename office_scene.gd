extends Control

var dialogue = [
	{"type": "player", "text": "Hello??"},
	{"type": "npc", "text": "Are you lost..."},
	{"type": "player", "text": "Uh...No?."},
	{"type": "desc", "text": "(WOW thats some attitude)."},
	{"type": "player", "text": "I actually live here,I was wondering if you could give me access to the lift?"},
	{"type": "npc", "text": "Door number?"},
	{"type": "player", "text": "35.."},
	{"type": "npc", "text": "......"},
	{"type": "player", "text": ".....uh...wha-"},
	{"type": "npc", "text": "You dont belong here."},
	{"type": "player", "text": "are you seriously going to make me take the long way round?"},
	{"type": "npc", "text": "....."},
	{"type": "player", "text": "fine...(That was odd)."}
]

var dialogue_index = 0
var is_typing = false
var full_text = ""
var current_text = ""
var current_color = "#ffffff"
var typing_speed = 0.03
var using_sound2 = false

func _ready():
	$hint.visible = false
	$character.visible = false
	$character.play("idle")

	if $DialogueBox/DialogueLabel is RichTextLabel:
		$DialogueBox/DialogueLabel.bbcode_enabled = true

	start_dialogue()

func start_dialogue():
	dialogue_index = 0
	show_line()

func show_line():
	var line = dialogue[dialogue_index]

	match line["type"]:
		"desc":
			current_color = "#ffffff"
		"player":
			current_color = "#4a9eff"
		"npc":
			current_color = "#ff7aa2"

	full_text = line["text"]
	current_text = ""
	is_typing = true
	using_sound2 = false

	$DialogueBox/DialogueLabel.clear()
	$hint.visible = false

	$dialogue_sound.stop()
	$sound2.stop()

	if dialogue_index == 3 or dialogue_index == 9:
		using_sound2 = true
		$sound2.play()
	else:
		$dialogue_sound.play()

	if dialogue_index >= 1:
		$character.visible = true
		$character.play("idle")
	else:
		$character.visible = false
		$character.stop()

	type_text()

func set_dialogue_text(text_to_show: String):
	$DialogueBox/DialogueLabel.clear()
	$DialogueBox/DialogueLabel.append_text(
		"[color=%s]%s[/color]" % [current_color, text_to_show]
	)

func type_text():
	for i in range(full_text.length()):
		if !is_typing:
			$dialogue_sound.stop()
			return

		current_text += full_text[i]
		set_dialogue_text(current_text)

		await get_tree().create_timer(typing_speed).timeout

	is_typing = false
	$hint.visible = true

	# Only stop the normal typing sound here.
	# Let sound2 finish naturally.
	if !using_sound2:
		$dialogue_sound.stop()

func _input(event):
	if event.is_action_pressed("ui_accept") or (event is InputEventMouseButton and event.pressed):
		if is_typing:
			is_typing = false
			set_dialogue_text(full_text)
			$hint.visible = true   

			# Stop only the regular typing sound on skip.
			# Leave sound2 alone so it can finish.
			if !using_sound2:
				$dialogue_sound.stop()
		else:
			next_line()

func next_line():
	dialogue_index += 1

	if dialogue_index < dialogue.size():
		show_line()
	else:
		$dialogue_sound.stop()
		# Optional: stop sound2 here only when leaving the scene
		$sound2.stop()
		SceneTransition.change_scene("res://mainfinal.tscn")
