extends CharacterBody3D

@export var speed := 3.0
@export var mouse_sensitivity := 0.002
@export var controller_look_sensitivity := 2.5
@export var controller_deadzone := 0.15

@onready var camera: Camera3D = $PlayerCamera

var pitch := 0.0

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

	if GlobalData.returning_from_encounter:
		global_position = GlobalData.return_position
		global_rotation = GlobalData.return_rotation
		GlobalData.returning_from_encounter = false

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		rotation.y -= event.relative.x * mouse_sensitivity

		pitch -= event.relative.y * mouse_sensitivity
		pitch = clamp(pitch, deg_to_rad(-60), deg_to_rad(60))
		camera.rotation.x = pitch

func _physics_process(delta):
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")

	var direction := (global_transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	velocity.x = direction.x * speed
	velocity.z = direction.z * speed

	handle_controller_look(delta)

	move_and_slide()

func handle_controller_look(delta):
	var look_dir := Input.get_vector("look_left", "look_right", "look_up", "look_down")

	if look_dir.length() < controller_deadzone:
		return

	rotation.y -= look_dir.x * controller_look_sensitivity * delta

	pitch -= look_dir.y * controller_look_sensitivity * delta
	pitch = clamp(pitch, deg_to_rad(-60), deg_to_rad(60))
	camera.rotation.x = pitch
