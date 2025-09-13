extends CharacterBody2D
func physics_process(delta):
	velocity.x = 300
	move_and_slide()
