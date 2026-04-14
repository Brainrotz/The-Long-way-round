extends Node

var rect
var tween

func _ready():
	var canvas = CanvasLayer.new()
	canvas.layer = 1000
	add_child(canvas)

	rect = ColorRect.new()
	rect.color = Color.BLACK
	rect.size = get_viewport().size
	rect.visible = false

	canvas.add_child(rect)

	get_tree().scene_changed.connect(_on_scene_changed)

func change_scene(path):
	rect.visible = true

	if tween:
		tween.kill()

	tween = create_tween()
	tween.tween_property(rect, "color:a", 1.0, 0.3)
	tween.tween_callback(get_tree().change_scene_to_file.bind(path))

func _on_scene_changed():
	tween = create_tween()
	tween.tween_property(rect, "color:a", 0.0, 0.3)
	tween.tween_callback(func(): rect.visible = false)
	
