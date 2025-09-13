extends CharacterBody2D       # Godot 4
# extends KinematicBody2D     # if Godot 3

@export var speed := 200.0
@export var jump_force := 400.0
@export var gravity := 900.0

func _physics_process(delta):
	# Horizontal input
	var direction := Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	velocity.x = direction * speed

	# Apply gravity
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = 0.0

	# Jump
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		velocity.y = -jump_force

	move_and_slide()
