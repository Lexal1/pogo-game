extends Area2D

@export var bounce = -100
var pogobounce = bounce + -100
@export var DestroyObject = false
@export var PlayAnim = false


func _ready():
	pass

func _on_Area2D_body_entered(body):
	if body is Player: # are you actually the player
		
		if body.pogo_mode == true:
			body.velocity.y = pogobounce # replace with a tripping system maybe?
			
		if body.pogo_mode == false:
			body.velocity.y = clamp(bounce+body.JUMP, 0, bounce)
			if Input.is_action_pressed("ui_up"):
				body.velocity.y = clamp(bounce+body.JUMP, 0, bounce+-25)
	
	if DestroyObject == true:
		get_parent()._kill()
	
	if PlayAnim == true:
		get_parent()._play_anim()
