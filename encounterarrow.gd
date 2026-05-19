extends AnimatedSprite3D

@export var animation_name := "idle"
@export var float_distance := 0.25
@export var float_speed := 0.6

var start_y := 0.0

func _ready():
	visible = true
	
	play(animation_name)

	start_y = position.y
	start_float()

func start_float():
	var tween = create_tween()
	tween.set_loops()

	tween.tween_property(
		self,
		"position:y",
		start_y + float_distance,
		float_speed
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

	tween.tween_property(
		self,
		"position:y",
		start_y,
		float_speed
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
