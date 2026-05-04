extends Node3D

@onready var anim: AnimationPlayer = $rig/AnimationPlayer

func _ready():
	anim.play("Idle")
