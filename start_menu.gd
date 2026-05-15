extends Control

@onready var easy_mode_button = $VBoxContainer/EasyMode

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	$VBoxContainer/Start.pressed.connect(_on_start_pressed)
	$VBoxContainer/Quit.pressed.connect(_on_quit_pressed)

	$VBoxContainer/Start.mouse_entered.connect(_on_start_mouse_entered)
	$VBoxContainer/Quit.mouse_entered.connect(_on_quit_mouse_entered)

	easy_mode_button.visible = GlobalData.easy_mode_unlocked

	if easy_mode_button.visible:
		easy_mode_button.pressed.connect(_on_easy_mode_pressed)
		easy_mode_button.mouse_entered.connect(_on_easy_mode_mouse_entered)

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

func _on_quit_mouse_entered() -> void:
	$hover.play()

func _on_start_mouse_entered() -> void:
	$hover.play()

func _on_easy_mode_mouse_entered() -> void:
	$hover.play()
