extends Area2D

@onready var sprite = $AnimatedSprite2D
var animdone = false
# Called when the node enters the scene tree for the first time.

func _ready():
	pass

func _play_anim():
	sprite.play("springing")

