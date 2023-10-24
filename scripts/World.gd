#keep your nose out of here!
extends Node2D
@onready var console = $Console
@onready var player = $CharacterBody2D
func _ready():
	console.visible = false
	RenderingServer.set_default_clear_color(Color.SKY_BLUE)

func _physics_process(delta):
	if Input.is_action_just_pressed("Cheater") and console.visible==false:
		console.visible = true
		print("cheater cheater pumpkin eater")
	elif Input.is_action_just_pressed("Cheater") and console.visible==true: console.visible = false

func _on_console_text_submitted(command):
	match command:
		"win": print("a winner is you")
		"motherlode","rosebud": player.score += 999999999
		"commanderkeen": print("\"The universe is toast!\""); player.CanPogo = !player.CanPogo
		"godmode": print("\"Hmm, maybe turbotax doesn't have cheat codes.\"")
		"spin": print("\"speen\""); player.pogo_mode = !player.pogo_mode
		"help","SOS": print("like i'm going to help YOU.")
		"you should KILL yourself NOW","kill": player.state = 3
		"no tv and no beer": print("\"Don't mind if I do!\"")
		
		#keep at the bottom
		_: print("Invalid command")
