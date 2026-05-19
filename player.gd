extends CharacterBody3D

@export var speed := 3.0

# Lower = tighter/slower mouse turning
@export var mouse_sensitivity := 0.001

# Stops big mousepad swipes from swinging the camera too far
@export var max_mouse_turn := 16.0

# Controller look settings
@export var controller_look_sensitivity := 1.6
@export var controller_deadzone := 0.18
@export var controller_look_curve := 1.5
@export var max_controller_turn := 1.8

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
		var mouse_x = clamp(event.relative.x, -max_mouse_turn, max_mouse_turn)
		var mouse_y = clamp(event.relative.y, -max_mouse_turn, max_mouse_turn)

		rotation.y -= mouse_x * mouse_sensitivity

		pitch -= mouse_y * mouse_sensitivity
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

	var curved_x = sign(look_dir.x) * pow(abs(look_dir.x), controller_look_curve)
	var curved_y = sign(look_dir.y) * pow(abs(look_dir.y), controller_look_curve)

	curved_x = clamp(curved_x, -max_controller_turn, max_controller_turn)
	curved_y = clamp(curved_y, -max_controller_turn, max_controller_turn)

	rotation.y -= curved_x * controller_look_sensitivity * delta

	pitch -= curved_y * controller_look_sensitivity * delta
	pitch = clamp(pitch, deg_to_rad(-60), deg_to_rad(60))
	camera.rotation.x = pitch
