extends Area3D

@export var encounter_scene_path := "res://encounter_3.tscn"

var triggered := false

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if triggered:
		return

	if GlobalData.encounter_3_done:
		return

	if body.name == "Player":
		triggered = true

		# Save return position
		GlobalData.return_position = body.global_position
		GlobalData.return_rotation = body.global_rotation

		GlobalData.encounter_3_done = true

		get_tree().change_scene_to_file(encounter_scene_path)
