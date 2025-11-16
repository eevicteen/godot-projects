extends CharacterBody3D

@onready var head = $Head
@onready var cam = $Head/Camera3D
@onready var aim_target = $AimTarget
@onready var camera_anim = $Head/Camera3D/AnimationPlayer

var sensitivity := 0.06
var pitch := 0.0   # X rotation
var yaw := 0.0     # Y rotation
var max_pitch := 40
var min_pitch := -40
var move_input: Vector3 = Vector3.ZERO
@export var move_speed := 5.0
func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event):
	if event is InputEventMouseMotion:
		# Horizontal rotation: yaw -> rotate player
		yaw -= event.relative.x * sensitivity
		rotation_degrees.y = yaw

		# Vertical rotation: pitch -> rotate head
		pitch -= event.relative.y * sensitivity
		pitch = clamp(pitch, min_pitch, max_pitch)
		head.rotation_degrees.x = pitch

func _process(delta):
	# Handle shooting
	if Input.is_action_just_pressed('aim'):
		camera_anim.play("aim")
	if Input.is_action_just_released('aim'):
		camera_anim.play_backwards('aim')
	if Input.is_action_just_pressed("shoot"):
		shoot()
	

func _physics_process(delta): 
	handle_movement(delta) 
	
func handle_movement(delta): 
	var input_dir = Vector3.ZERO 
	input_dir.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left") 
	input_dir.z = Input.get_action_strength("move_forward") - Input.get_action_strength("move_backward") 
	input_dir = input_dir.normalized() 
	if input_dir != Vector3.ZERO: 
		var forward = global_transform.basis.z 
		forward.y = 0 
		forward = forward.normalized() 
		var right = -global_transform.basis.x 
		right.y = 0 
		right = right.normalized() 
		move_input = (forward * input_dir.z + right * input_dir.x).normalized() 
	else: 
		move_input = Vector3.ZERO 
	velocity = move_input * move_speed 
	move_and_slide()

func shoot():
	var viewport_center = get_viewport().get_visible_rect().size / 2

	# Origin and direction from camera
	var origin = cam.project_ray_origin(viewport_center)
	var dir = cam.project_ray_normal(viewport_center).normalized()

	# Fire the shot
	aim_target.fire_shot(origin, dir)
