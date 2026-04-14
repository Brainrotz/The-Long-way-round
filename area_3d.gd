extends Area3D

@export var next_scene: String = "res://encounter_1.tscn"
@export var hint_path: NodePath

var hint

func _ready():
	if hint_path != NodePath():
		hint = get_node(hint_path)
		hint.visible = true  # always show hint

func _process(_delta):
	if Input.is_action_just_pressed("interact"):
		print("DEBUG: forcing interaction")
		SceneTransition.change_scene(next_scene)
