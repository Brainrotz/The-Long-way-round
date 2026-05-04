extends Node3D

@onready var anim: AnimationPlayer = $AnimationPlayer

func _ready():
	anim.get_animation("Idle").loop = true
	anim.play("Idle")
