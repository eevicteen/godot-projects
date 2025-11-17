extends CharacterBody3D

#  Nodes 
@onready var head = $Head
@onready var cam = $Head/Camera3D
@onready var aim_target = $AimTarget
@onready var camera_anim = $Head/Camera3D/AnimationPlayer

# Movement
var sensitivity := 0.06
var pitch := 0.0
var yaw := 0.0
var max_pitch := 20
var min_pitch := -20
var move_input: Vector3 = Vector3.ZERO
@export var move_speed := 5.0

# Projectile 
@export var projectile: PackedScene 

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
	# Handle aiming animation
	if Input.is_action_just_pressed('aim'):
		camera_anim.play("aim")
	if Input.is_action_just_released('aim'):
		camera_anim.play_backwards('aim')

	# Handle shooting
	if Input.is_action_just_pressed("shoot"):
		#print("shoot")
		shoot()

func _physics_process(delta): 
	handle_movement(delta) 
	
func handle_movement(delta): 
	var input_dir = Vector3.ZERO 
	input_dir.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left") 
	input_dir.z = Input.get_action_strength("move_forward") - Input.get_action_strength("move_backward") 
	input_dir = input_dir.normalized() 
	if input_dir != Vector3.ZERO: 
		var forward = -global_transform.basis.z 
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
	var origin = cam.project_ray_origin(viewport_center)
	var dir = cam.project_ray_normal(viewport_center).normalized()
	aim_target.fire_shot(origin, dir)  

	if projectile:
		#print("projectile working") 
		var proj_instance = projectile.instantiate()
		get_tree().current_scene.add_child(proj_instance)
		
		#Spawn slightly in front of the camera
		var spawn_pos = cam.global_transform.origin + (-cam.global_transform.basis.z) * 1.5
		proj_instance.global_transform.origin = spawn_pos

		# Target point a bit further forward
		var target_point = spawn_pos + (-cam.global_transform.basis.z) * 10
		proj_instance.setup(target_point, 5.0)
		
		
