extends CharacterBody2D

var direction = Vector2.RIGHT

@onready var sprite = $AnimatedSprite2D
@onready var LedgeCheck = $LedgeCheck

func _ready():
	pass

func _process(delta):
	var found_wall = is_on_wall()
	var found_ledge = not LedgeCheck.is_colliding()
	if found_wall or found_ledge:
		direction *= -1
		scale.x *= -1
	
	velocity = direction * 25
	set_velocity(velocity)
	set_up_direction(Vector2.UP)
	move_and_slide()
