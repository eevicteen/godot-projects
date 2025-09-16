extends CharacterBody2D

@export var speed := 10.0
var speed_multiplier := 30.0

@onready var anim := $AgentAnimator/AnimatedSprite2D
@onready var idle_timer := $IdleTimer
@onready var jump_start_timer := $JumpStartTimer

var is_idle:= false
var was_on_floor:= true

signal idle

func _ready() -> void:
	idle.connect(_on_idle)
	idle_timer.timeout.connect(_on_idle_timer_timeout)
	

func _physics_process(delta: float) -> void:
	# Apply gravity
	if not is_on_floor():
		velocity.y += 980 * delta  # gravity

	# Jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = -500
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
		if was_on_floor:
			anim.play("jump_start")
			jump_start_timer.start(0.1) 
			was_on_floor = false
		elif velocity.y < 0:
			if jump_start_timer.is_stopped():
				if anim.animation != "jump_up":
					anim.play("jump_up")
		else:
			if anim.animation != "jump_down":
				anim.play("jump_down")
	else:
		if not was_on_floor:
			anim.play('still')
			was_on_floor = true
		if abs(velocity.x) > 10:
			if anim.animation != "run":
				anim.play("run")
				is_idle = false
		else:
			if not is_idle:
				anim.play("still")
				is_idle = true
				idle.emit()

func _on_idle() -> void:
	print("Idle signal received → starting timer")
	idle_timer.start(3)

func _on_idle_timer_timeout() -> void:
	print("Timer finished → switching to idle animation")
	anim.play("idle")
