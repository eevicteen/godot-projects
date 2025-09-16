extends CharacterBody2D

const SPEED := 300.0            # horizontal speed in pixels/sec
const JUMP_VELOCITY := -1200.0   # negative = up

func _ready() -> void:
	print("Player script READY – scene and script are running.")

func _physics_process(delta: float) -> void:
	# --- Debug prints to prove the function is running ---
	var dir := Input.get_axis("ui_left", "ui_right")
	print("direction:", dir, "  on_floor:", is_on_floor(), "  velocity:", velocity)

	# --- Gravity ---
	if not is_on_floor():
		velocity.y += ProjectSettings.get_setting("physics/2d/default_gravity") * delta

	# --- Jump ---
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		print("Jump triggered!")

	# --- Horizontal movement ---
	if dir != 0:
		velocity.x = dir * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
