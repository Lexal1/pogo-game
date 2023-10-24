extends CharacterBody2D

var direction = Vector2.LEFT

@onready var sprite = $sprite
@onready var LedgeCheck = $ledgecheck
@onready var WallCheck = $wallcheck

func _ready():
	pass

func _process(delta):
	var found_wall = WallCheck.is_colliding()
	var found_ledge = not LedgeCheck.is_colliding()
	if found_wall or found_ledge:
		direction *= -1
		scale.x *= -1
	
	velocity = direction * 25
	set_velocity(velocity)
	set_up_direction(Vector2.UP)
	move_and_slide()

func _kill():
	queue_free()
	
