extends Area2D

@export var regbounce = -100
@export var pogobounce = -195


func _ready():
	pass

func _on_Area2D_body_entered(body):
	if body is Player:
		if body.pogo_mode == true:
			body.velocity.y = pogobounce
		else:
			body.velocity.y = regbounce
