extends CharacterBody2D
class_name Player
var pogo_mode = false
var sprite_def = ""
@onready var sprite = $AnimatedSprite2D

#ARE YOU READY?
func _ready():
	sprite.play("default")

func _physics_process(delta):
	applygravity()
	
	var xInput = Vector2.ZERO
	xInput.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	
	if xInput.x == 0:
		rotation_degrees = 0
		applyfriction()
		sprite.play("default")
	else:
		applyacceleration(xInput.x)
		sprite.play("run")
		sprite.flip_h = xInput.x < 0
		if pogo_mode == true:
			rotation_degrees = xInput.x * 10
		
		
		#if pogo_mode == true:
		#	rotation_degrees += xInput.x + 10 #this is really funny, it makes you do flips

#jump
	if is_on_floor():
		if Input.is_action_just_pressed("ui_up"):
			velocity.y = -145

#pogo trigger
		if Input.is_action_just_pressed("ui_down") and pogo_mode == false:
			pogo_mode = true
			print("yo pogo")

#pogo code
		while pogo_mode == true:
			sprite.play("pogo")
			if is_on_floor():
				sprite.play("pogoLand")
				velocity.y = -75
			if Input.is_action_pressed("ui_up"):
				velocity.y = -175
			if Input.is_action_pressed("ui_end"):
				print("no pogo")
				pogo_mode = false
				sprite.play("default")
			break

#short jumps
	else:
		if pogo_mode == true:
			sprite.play("pogo")
		else:
			sprite.play("jump")
		if Input.is_action_just_released("ui_up") and velocity.y < -61:
			velocity.y = -61
		if velocity.y > 0:
			if pogo_mode == true:
				sprite.play("pogo")
			else:
				sprite.play("fall")
			velocity.y += 5
	
	set_velocity(velocity)
	set_up_direction(Vector2.UP)
	move_and_slide()
	velocity = velocity

func applygravity():
	velocity.y += 5
	velocity.y = min(velocity.y, 400)

func applyfriction():
	velocity.x = move_toward(velocity.x, 0, 10)

func applyacceleration(amount):
	velocity.x = move_toward(velocity.x, 50 * amount, 10)

