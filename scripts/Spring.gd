extends Area2D

@onready var sprite = $AnimatedSprite2D
# Called when the node enters the scene tree for the first time.
func _ready():
	pass



func _process(delta):
	pass

func _on_Spring_body_entered(body):
	if body is Player:
		sprite.play("springing")
	if sprite.get_frame() == 7:
		sprite.set_frame(0)


