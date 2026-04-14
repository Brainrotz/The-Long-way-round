extends CanvasLayer

var lines = [
	"you meet a strange figure.",
	"they stare silently.",
	"welcome to the city..."
]

var index = 0

@onready var label = $Panel/Label

func _ready():
	hide()

func start_vn():
	index = 0
	show()
	label.text = lines[index]

func _input(event):

	if visible and event.is_action_pressed("ui_accept"):

		index += 1

		if index >= lines.size():
			hide()
		else:
			label.text = lines[index]
