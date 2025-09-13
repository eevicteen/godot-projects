extends CharacterBody2D

@export var speed := 10.0
var speed_multiplier := 30.0

@onready var anim := $AgentAnimator/AnimatedSprite2D

func _physics_process(delta: float) -> void:
	# Apply gravity
	if not is_on_floor():
		velocity.y += 980 * delta  # gravity

	# Jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = -300
		anim.play("jump")

	# Horizontal movement
	var dir = Input.get_axis("ui_left", "ui_right")
	velocity.x = dir * 300
	if dir != 0:
		anim.flip_h = dir < 0

	# Move
	move_and_slide()

	# Animation state machine
	if not is_on_floor():
		# In air → jump animation
		if anim.animation != "jump":
			anim.play("jump")
	else:
		# On ground → run if moving, idle if still
		if abs(velocity.x) > 10:  # small threshold avoids flicker
			if anim.animation != "run":
				anim.play("run")
		else:
			if anim.animation != "idle":
				anim.play("idle")

	# Debug
	# print("Animation playing:", anim.animation, " vel:", velocity, " on_floor:", is_on_floor())
