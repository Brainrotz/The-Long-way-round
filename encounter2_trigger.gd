extends Area3D

@export var encounter_scene_path := "res://encounter_2.tscn"
@export var walk_speed := 2.0
@export var stop_distance := 0.1
@export var stop_point: Marker3D

var player: CharacterBody3D
var moving_player := false
var triggered := false

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if triggered:
		return

	if GlobalData.encounter_2_done:
		return

	if body.name == "Player":
		triggered = true
		player = body

		GlobalData.return_position = player.global_position
		GlobalData.return_rotation = player.global_rotation

		player.velocity = Vector3.ZERO
		player.set_physics_process(false)

		moving_player = true

func _physics_process(_delta):
	if not moving_player or player == null:
		return

	if stop_point == null:
		push_error("EncounterTrigger2: stop_point is not assigned.")
		return

	var target := stop_point.global_position
	target.y = player.global_position.y

	var to_target := target - player.global_position

	if to_target.length() <= stop_distance:
		moving_player = false
		player.velocity = Vector3.ZERO
		player.move_and_slide()

		GlobalData.encounter_2_done = true
		get_tree().change_scene_to_file(encounter_scene_path)
		return

	var direction := to_target.normalized()

	var target_angle = atan2(-direction.x, -direction.z)
	player.rotation.y = lerp_angle(player.rotation.y, target_angle, 0.1)

	player.velocity = Vector3.ZERO
	player.velocity.x = direction.x * walk_speed
	player.velocity.z = direction.z * walk_speed

	player.move_and_slide()
