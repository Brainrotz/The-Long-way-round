extends Node3D

@onready var player = $Player
@onready var camera = $Player/PlayerCamera

var speed = 6

func _process(delta):

	var dir = Vector3.ZERO

	if Input.is_action_pressed("ui_up"):
		dir -= player.transform.basis.z
	if Input.is_action_pressed("ui_down"):
		dir += player.transform.basis.z
	if Input.is_action_pressed("ui_left"):
		dir -= player.transform.basis.x
	if Input.is_action_pressed("ui_right"):
		dir += player.transform.basis.x

	dir.y = 0

	if dir != Vector3.ZERO:
		player.translate(dir.normalized() * speed * delta)
