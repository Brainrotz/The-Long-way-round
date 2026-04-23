extends Area3D

@export var next_scene: String = "res://encounter_3.tscn"
@export var hint_path: NodePath

var hint

func _ready():
	if hint_path != NodePath():
		hint = get_node(hint_path)
		hint.visible = true

func _process(_delta):
	if Input.is_action_just_pressed("interact_d"):
		print("DEBUG: forcing interaction")
		SceneTransition.change_scene(next_scene)
