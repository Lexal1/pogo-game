extends Area2D

@export var type = 0
@onready var sprite = $sprite




# Called when the node enters the scene tree for the first time.
func _ready():
	if type == 0:
		sprite.play("coin")
	if type == 1:
		sprite.play("pogo")

func _process(delta):
	pass

func _on_body_entered(body):
	if body is Player:
		if type == 0:
			body.score += 10
			queue_free()
		if type == 1:
			body.CanPogo = true
			queue_free()
