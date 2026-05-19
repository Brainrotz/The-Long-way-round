extends Control

@export var scroll_speed: float = 45.0
@export var return_scene: String = "res://start_menu.tscn"

@onready var credits_text = $CreditsText

var finished = false

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	if credits_text is RichTextLabel:
		credits_text.bbcode_enabled = true
		credits_text.fit_content = true
		credits_text.scroll_active = false

		credits_text.text = """
[center][font_size=36]The Long Way Round[/font_size]

[font_size=22]Created by[/font_size]
Cristina Bianchi


[font_size=22]Game Design[/font_size]
Cristina Bianchi

[font_size=22]Writing[/font_size]
Cristina Bianchi

[font_size=22]Programming[/font_size]
Cristina Bianchi

[font_size=22]Art and Visual Design[/font_size]
Cristina Bianchi
Calix Borrero Diaz

[font_size=22]Sound Design[/font_size]
Cristina Bianchi


Made with Godot Engine


[font_size=24]Assets and Resources Used[/font_size]


[font_size=22]Fonts[/font_size]
Pixel Font Awesome
somepx.itch.io/pixel-font-awesome
Purchased asset
Used throughout the game


[font_size=22]Shaders[/font_size]
Warped Fractal Noise Shader
godotshaders.com/shader/warped-fractal-noise
Used for start menu and credits

Balatro Original Paint Background Shader
godotshaders.com/shader/balatro-original-paint-background
Used as shader background in the card mini-game


[font_size=22]Music and Sound Effects[/font_size]
Start Menu Sound Effect
freesound.org/people/plasterbrain/sounds/243020

Start Menu Music
freesound.org/people/magmadiverrr/sounds/661248

Start Menu Hover Sound
freesound.org/people/plasterbrain/sounds/237422

Talking Bleep Sound Effect
freesound.org/people/malakme/sounds/468927

Awkward Sound Effect
freesound.org/people/plasterbrain/sounds/395502

Background Music Pack
tallbeard.itch.io/music-loop-bundle


[font_size=22]Environment Assets[/font_size]
Buildings
elbolilloduro.itch.io/buildings
CC0 1.0 Universal

Stylized Ground Textures
kalponic-studio.itch.io/stylized-ground-textures
Licence for everyone
Used for ground and floor textures

PSX Multi-Section Apartment Building
kasuga.itch.io/psx-multi-section-apartment-building
Used as main building

PS1 Style Brownstone Buildings
pepperonijabroni.itch.io/ps1-style-brownstone-buildings
Used as building 2

PSX Style Barriers
valsekamerplant.itch.io/psx-style-barriers
Used for barriers

PSX Style Walls and Fences
valsekamerplant.itch.io/psx-style-walls-fences
Used for additional fences

PSX Waste
daniel-jurys.itch.io/psx-waste
Used for trash assets


[font_size=22]Props and Vehicles[/font_size]
PSX Siren
sketchfab.com/3d-models/psx-siren-7d90128c3f234db29cf2e5a288d59878
Used as siren asset

PSX Style Chain Fence
sketchfab.com/3d-models/psx-style-chain-fence-57d3e84f276d46c6b4bab1e502d9a4d5
Used as chain fence asset

PSX Shipping Containers 2
sketchfab.com/3d-models/psx-shipping-containers-2-c4a68cee7a184f15a553a9d53d66f94e
Used as shipping containers

PSX Passat LS 1978
sketchfab.com/3d-models/psx-passat-ls-1978-f56cc9a3ff76418fb30ece32d063f608
Used as white car

PSX Tree
sketchfab.com/3d-models/psx-tree-4028007f24e14160be6deed950789cbe
Used as background tree

Low Poly PSX/PS2 Trash Filled Metal Dumpster
sketchfab.com/3d-models/low-poly-psxps2-trash-filled-metal-dumpster-7d149495e5004301b518ce3bd4895484
Used as dumpster asset

Cop Car
fab.com/listings/9ff39581-d010-4497-acff-872f6f6c3616

PSX Shopping Cart
sketchfab.com/3d-models/psx-shopping-cart-96534b56f0d9487db08f00f1f9301fa1
Used as shopping cart asset

Retro Car With Interior - PSX Asset
sketchfab.com/3d-models/retro-car-with-interior-psx-asset-free-6d94b353f7b0429d9c6092bd823951ec
Used as black car

Animated Arrows & Cursors
spikerman.itch.io/animated-arrows-cursors
Used as encounter direction arrow

[font_size=22]Character Assets[/font_size]
Characters PSX
elbolilloduro.itch.io/characters-psx
Used for police NPCs, firefighter NPC, and background NPCs

PS1 Character with Actions
sketchfab.com/3d-models/ps1-character-with-actions-f6087d44b55f4cb6b3809ad915fab069
Used for Encounter 1 model

Simple Low Poly Character
sketchfab.com/3d-models/simple-low-poly-character-5ee952af02634ffeab649ab9fba66bfb
Used for Encounter 2 model

PSX GRAPHICS | Low Poly Woman | Free Download
sketchfab.com/3d-models/psx-graphics-low-poly-woman-free-download-08dea1dcd280451da4a8e621588409a3
Used for Encounter 3 model


[font_size=22]Special Thanks[/font_size]
Tutors, playtesters, friends and family


Thank you for playing[/center]
"""
	else:
		credits_text.text = """
The Long Way Round

Created by
Cristina Bianchi

Assets and Resources Used

Full asset credits included in RichTextLabel version.

Thank you for playing
"""

	await get_tree().process_frame

	# Make the text box tall enough for ALL credits
	if credits_text is RichTextLabel:
		credits_text.size.y = credits_text.get_content_height() + 200
	else:
		credits_text.size.y = credits_text.get_line_count() * 40

	credits_text.position.y = get_viewport_rect().size.y + 50

func _process(delta):
	if finished:
		return

	credits_text.position.y -= scroll_speed * delta

	var credits_height = credits_text.size.y

	if credits_text.position.y + credits_height < -50:
		finish_credits()

func _input(event):
	if event.is_action_pressed("ui_accept") or (event is InputEventMouseButton and event.pressed):
		finish_credits()

func finish_credits():
	if finished:
		return

	finished = true
	SceneTransition.change_scene(return_scene)
