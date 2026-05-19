extends Area3D

@export var encounter_scene_path := "res://encounter_2.tscn"

var triggered := false

@onready var arrow = $Encounterarrow2

func _ready():
	body_entered.connect(_on_body_entered)

	if GlobalData.encounter_2_done:
		arrow.visible = false
	else:
		arrow.visible = true

func _on_body_entered(body):
	if triggered:
		return

	if GlobalData.encounter_2_done:
		arrow.visible = false
		return

	if body.name == "Player":
		triggered = true

		arrow.visible = false

		# Save return position
		GlobalData.return_position = body.global_position
		GlobalData.return_rotation = body.global_rotation

		GlobalData.encounter_2_done = true

		call_deferred("go_to_encounter")

func go_to_encounter():
	get_tree().change_scene_to_file(encounter_scene_path)
