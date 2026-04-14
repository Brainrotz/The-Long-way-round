extends Control

@onready var base_card = $BaseCard
@onready var cards = [
	$Card1,
	$Card2,
	$Card3,
	$Card4,
	$Card5
]

@onready var reveal_card = $RevealCard

var selected_card: TextureButton = null
var losses = 0
var max_losses = 3
var waiting_for_continue = false

var loss_dialogue = [
	("Oh... that's peak."),
	("Well..."),
	("Three times. Man, you have terrible luck.")
]

var original_positions = {}
var hover_height = 20.0

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	if $ResultLabel is RichTextLabel:
		$ResultLabel.bbcode_enabled = true

	for card in cards:
		original_positions[card] = card.position
		card.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT_CENTERED

	setup_board()
	connect_cards()
	$HigherButton.pressed.connect(_on_higher_pressed)
	$LowerButton.pressed.connect(_on_lower_pressed)
	start_round()

func setup_board():
	base_card.texture = preload("res://cards/7.jpg")

	for card in cards:
		card.texture_normal = preload("res://cards/back.jpg")

	reveal_card.visible = false

func connect_cards():
	for card in cards:
		card.pressed.connect(func(): _on_card_selected(card))
		card.mouse_entered.connect(func(): hover_up(card))
		card.mouse_exited.connect(func(): hover_down(card))

func start_round():
	waiting_for_continue = false
	selected_card = null

	if $ResultLabel is RichTextLabel:
		$ResultLabel.text = "[color=black]Pick a card, then guess if it is higher or lower than 7.[/color]"
	else:
		$ResultLabel.text = "Pick a card, then guess if it is higher or lower than 7."

	$ContinueHint.text = ""

	$HigherButton.disabled = true
	$LowerButton.disabled = true

	for card in cards:
		card.texture_normal = preload("res://cards/back.jpg")
		card.disabled = false
		card.position = original_positions[card]

	reveal_card.visible = false

func _on_card_selected(card: TextureButton):
	if waiting_for_continue:
		return

	selected_card = card

	for c in cards:
		c.position = original_positions[c]

	card.position = original_positions[card] + Vector2(0, -hover_height)

	$HigherButton.disabled = false
	$LowerButton.disabled = false

	if $ResultLabel is RichTextLabel:
		$ResultLabel.text = "[color=black]You picked a card. Will it be higher or lower than 7?[/color]"
	else:
		$ResultLabel.text = "You picked a card. Will it be higher or lower than 7?"

func _on_higher_pressed():
	resolve_guess("higher")

func _on_lower_pressed():
	resolve_guess("lower")

func resolve_guess(choice: String):
	if selected_card == null:
		return

	var revealed_value = rigged_card(choice)
	losses += 1

	$HigherButton.disabled = true
	$LowerButton.disabled = true

	for card in cards:
		card.disabled = true

	selected_card.texture_normal = load("res://cards/%d.jpg" % revealed_value)

	var line = loss_dialogue[losses - 1]
	var dialogue_line = "\"%s\"" % line

	if $ResultLabel is RichTextLabel:
		$ResultLabel.text = "[color=black]You guessed %s.\nThe card was %d.\nYou lose.[/color]\n\n[color=green]%s[/color]" % [
			choice.capitalize(),
			revealed_value,
			dialogue_line
		]
	else:
		$ResultLabel.text = "You guessed %s.\nThe card was %d.\nYou lose.\n\n%s" % [
			choice.capitalize(),
			revealed_value,
			dialogue_line
		]

	$ContinueHint.text = "[Press Space to continue]"
	waiting_for_continue = true

func rigged_card(choice: String) -> int:
	if choice == "higher":
		return randi_range(2, 6)
	else:
		return randi_range(8, 10)

func _input(event):
	if not waiting_for_continue:
		return

	if event.is_action_pressed("ui_accept"):
		next_step()

func next_step():
	if losses >= max_losses:
		GlobalData.from_card_game = true
		SceneTransition.change_scene("res://encounter_1.tscn")
	else:
		start_round()

func hover_up(card: TextureButton):
	if waiting_for_continue:
		return
	if card == selected_card:
		return

	var tween = create_tween()
	tween.tween_property(
		card,
		"position",
		original_positions[card] + Vector2(0, -hover_height),
		0.1
	)

func hover_down(card: TextureButton):
	if waiting_for_continue:
		return
	if card == selected_card:
		return

	var tween = create_tween()
	tween.tween_property(
		card,
		"position",
		original_positions[card],
		0.1
	)
