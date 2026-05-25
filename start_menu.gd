extends Control

@onready var start_button = $VBoxContainer/Start
@onready var quit_button = $VBoxContainer/Quit
@onready var easy_mode_button = $VBoxContainer/EasyMode

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	start_button.focus_mode = Control.FOCUS_ALL
	quit_button.focus_mode = Control.FOCUS_ALL
	easy_mode_button.focus_mode = Control.FOCUS_ALL

	start_button.grab_focus()

	start_button.pressed.connect(_on_start_pressed)
	quit_button.pressed.connect(_on_quit_pressed)

	start_button.mouse_entered.connect(_on_start_hovered)
	quit_button.mouse_entered.connect(_on_quit_hovered)

	start_button.focus_entered.connect(_on_start_hovered)
	quit_button.focus_entered.connect(_on_quit_hovered)

	easy_mode_button.visible = GlobalData.easy_mode_unlocked

	if easy_mode_button.visible:
		easy_mode_button.pressed.connect(_on_easy_mode_pressed)
		easy_mode_button.mouse_entered.connect(_on_easy_mode_hovered)
		easy_mode_button.focus_entered.connect(_on_easy_mode_hovered)

func _on_start_pressed():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	$click.play()
	$AnimationPlayer.play("flash")

	await $AnimationPlayer.animation_finished

	SceneTransition.change_scene("res://intro_scene.tscn")

func _on_easy_mode_pressed():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	$click.play()
	$AnimationPlayer.play("flash_easy")

	await $AnimationPlayer.animation_finished

	SceneTransition.change_scene("res://easyintro.tscn")

func _on_quit_pressed():
	$click.play()
	get_tree().quit()

func _on_start_hovered() -> void:
	$hover.play()

func _on_quit_hovered() -> void:
	$hover.play()

func _on_easy_mode_hovered() -> void:
	$hover.play()
