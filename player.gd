
extends CharacterBody3D

@export var speed = 1
@export var mouse_sensitivity = 0.1

@onready var camera = $PlayerCamera

var rotation_x = 0  # up/down

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)  # lock mouse
	

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		# rotate player left/right
		rotate_y((-event.relative.x * mouse_sensitivity))
		
		# rotate camera up/down
		rotation_x += -event.relative.y * mouse_sensitivity
		rotation_x = clamp(rotation_x, -90, 90)
		camera.rotation_degrees.x = rotation_x

func _process(delta):
	var direction = Vector3.ZERO

	if Input.is_action_pressed("ui_up"):
		direction -= transform.basis.z
	if Input.is_action_pressed("ui_down"):
		direction += transform.basis.z
	if Input.is_action_pressed("ui_left"):
		direction -= transform.basis.x
	if Input.is_action_pressed("ui_right"):
		direction += transform.basis.x

	if direction != Vector3.ZERO:
		direction = direction.normalized() * speed * delta
		translate(direction)
