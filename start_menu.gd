extends Control

func _ready():
	$VBoxContainer/Start.pressed.connect(_on_start_pressed)
	$VBoxContainer/Quit.pressed.connect(_on_quit_pressed)
	$VBoxContainer/Start.mouse_entered.connect(_on_start_mouse_entered)
	$VBoxContainer/Quit.mouse_entered.connect(_on_quit_mouse_entered)

func _on_start_pressed():
	$click.play()
	$AnimationPlayer.play("flash")

	await $AnimationPlayer.animation_finished

	SceneTransition.change_scene("res://intro_scene.tscn")

func _on_quit_pressed():
	$click.play()
	get_tree().quit()

func _on_quit_mouse_entered() -> void:
	$hover.play()

func _on_start_mouse_entered() -> void:
	$hover.play()
