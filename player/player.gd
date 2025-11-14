extends CharacterBody3D

@export var move_speed := 5.0
@export var rotation_speed := 10.0

@export var camera: Camera3D
@export var camera_height := 1.6
@export var camera_distance := 6.0
@export var camera_offset_x := 1.2

@export var mouse_sensitivity := 0.003

var move_input: Vector3 = Vector3.ZERO


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _unhandled_input(event):
	if event is InputEventMouseMotion:
		handle_mouse_look(event)


func handle_mouse_look(event: InputEventMouseMotion):
	var yaw = -event.relative.x * mouse_sensitivity
	rotation.y += yaw   # rotate player (camera follows)


func _physics_process(delta):
	handle_movement(delta)
	handle_camera(delta)


# --------------------------------------------------------
# MOVEMENT (WASD relative to where the player is facing)
# --------------------------------------------------------
func handle_movement(delta):
	var input_dir = Vector3.ZERO
	input_dir.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_dir.z = Input.get_action_strength("move_forward") - Input.get_action_strength("move_backward")
	input_dir = input_dir.normalized()

	if input_dir != Vector3.ZERO:
		var forward = -global_transform.basis.z
		forward.y = 0
		forward = forward.normalized()

		var right = global_transform.basis.x
		right.y = 0
		right = right.normalized()

		move_input = (forward * input_dir.z + right * input_dir.x).normalized()
	else:
		move_input = Vector3.ZERO
	
	print("input_dir: ", input_dir)

	velocity = move_input * move_speed
	move_and_slide()


# --------------------------------------------------------
# THIRD-PERSON CAMERA (OTS)
# --------------------------------------------------------
func handle_camera(delta):
	if camera == null:
		return

	# Always follow behind the player regardless of model facing direction
	var forward = -transform.basis.z
	forward.y = 0
	forward = forward.normalized()

	var right = transform.basis.x

	var cam_target_pos = global_transform.origin + (forward * -camera_distance) + (right * camera_offset_x) + (Vector3.UP * camera_height)

	# Smooth follow movement
	camera.global_transform.origin = camera.global_transform.origin.lerp(cam_target_pos, delta * 8.0)

	# Look slightly above the player's origin (upper torso)
	camera.look_at(global_transform.origin + Vector3.UP * 1.5, Vector3.UP)
