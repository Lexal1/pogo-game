extends CharacterBody2D
class_name Player
@export var CanPogo = true
@onready var sprite: = $AnimatedSprite2D
@onready var pTimer: = $timers/pogo_timer
@onready var jTimer: = $timers/jump_timer
@onready var cTimer: = $timers/coyote_timer
@onready var ladder: = $LadderDetection

var score = 0
var state = MOVE

var pogo_mode = false
var jump_buffer = false
var coyote_jump = false

const MAX_POGO_SPEED = 50
const POGO_REG = -100
const POGO_JUMP = -195
const POGO_ROT = 5
const MAX_SPEED = 55
const JUMP = -175
const GRAVITY = 6
const CLIMB_SPD = 50

enum { MOVE, CLIMB, POGO, DEATH }

#ARE YOU READY?
func _ready():
	
	sprite.play("default")
	pTimer.set_one_shot(1)
	jTimer.set_one_shot(0.1)
	

func _physics_process(delta):
	
	var input = Vector2.ZERO
	input.x = Input.get_axis("Move_Left", "Move_Right")
	input.y = Input.get_axis("Move_Up", "Move_Down")
	
	match state:
		MOVE: move_state(input)
		CLIMB: climb_state(input)
		POGO: pogo_state(input)
		DEATH: death()
		
	

func move_state(xInput):
	
	#state changes
	if is_on_ladder() and Input.is_action_pressed("Move_Up"): state = CLIMB
	if is_on_ladder() and Input.is_action_pressed("Move_Down"): state = CLIMB
	if Input.is_action_just_pressed("Pogo_Toggle") and CanPogo: state = POGO; pTimer.start()
	#if the pogo toggle button is pressed, you are able to pogo, and the cooldown is not active, switch states to the move state and start the cooldown
	#the cooldown is so that it doesn't switch states withing a fraction of a second when you press the pogo key
	
	applygravity() #amazing
	
	#stand still
	if xInput.x == 0:
		
		rotation_degrees = 0
		applyfriction()
		sprite.play("default")
	
	#walk
	else:
		applyacceleration(xInput.x)
		sprite.play("run")
		sprite.flip_h = xInput.x < 0
	
	#jump
	if is_on_floor() or coyote_jump:
		if Input.is_action_just_pressed("Jump") or jump_buffer:
			velocity.y = JUMP
			jump_buffer = false
	
	else:
		
		sprite.play("jump")
		
		#short jump
		if Input.is_action_just_released("Jump") and velocity.y < -61:
			velocity.y = -61
		
		#jump buffer
		if Input.is_action_just_pressed("Jump"):
			jump_buffer = true
			jTimer.start()
		
		#falling animation
		if velocity.y > 0:
			sprite.play("fall")
			velocity.y += GRAVITY
		
	
	var was_on_floor = is_on_floor()
	
	set_velocity(velocity)
	set_up_direction(Vector2.UP)
	move_and_slide()
	
	var just_left_floor = not is_on_floor() and was_on_floor
	if velocity.y >= 0 and just_left_floor:
		coyote_jump = true
		cTimer.start()

func climb_state(input):
	if not is_on_ladder(): state = MOVE
	if input.length() != 0: sprite.play("climb")
	else: sprite.stop()
	velocity = input * CLIMB_SPD
	move_and_slide()

func pogo_state(input):
	if Input.is_action_just_pressed("Pogo_Toggle") and pTimer.get_time_left() == 0: state = MOVE; pTimer.start()
	#if the pogo toggle button is pressed and the cooldown is not active, switch states to the move state
	
	applygravity() #outstanding
	
	if input.x == 0:
		rotation_degrees = 0
		applyfriction()
		
	else:
		applyacceleration(input.x)
		sprite.flip_h = input.x < 0
		if !pogo_mode: rotation_degrees = input.x * POGO_ROT
		elif pogo_mode: rotation_degrees += input.x + POGO_ROT #spimn
		
	#pogo code
	sprite.play("pogo")
	
	if is_on_floor():
		velocity.y = POGO_REG
		sprite.play("pogoLand")
		
		if Input.is_action_pressed("Jump"):
			velocity.y = POGO_JUMP
	#short jumps
	if Input.is_action_just_released("Jump") and velocity.y < -61:
		velocity.y = -61
		
	if velocity.y > 0:
		sprite.play("pogoLand")
		velocity.y += GRAVITY
	
	set_velocity(velocity)
	set_up_direction(Vector2.UP)
	move_and_slide()

func is_on_ladder():
	if not ladder.is_colliding(): return false
	var collider = ladder.get_collider()
	if not collider is TileMap: return false
	return true

func applygravity():
	velocity.y += GRAVITY
	velocity.y = min(velocity.y, 400)

func applyfriction():
	velocity.x = move_toward(velocity.x, 0, 10)


func applyacceleration(amount):
	match state:
		MOVE: velocity.x = move_toward(velocity.x, MAX_SPEED * amount, 10)
		POGO: velocity.x = move_toward(velocity.x, MAX_POGO_SPEED * amount, 10)

func death():
	sprite.play("death")

func _on_jump_timer_timeout():
	jump_buffer = false

func _on_coyote_timer_timeout():
	coyote_jump = false
