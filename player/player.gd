extends CharacterBody3D

@onready var head = $Head
@onready var cam = $Head/SpringArm3D/Camera3D
@onready var camera_anim = $Head/SpringArm3D/Camera3D/AnimationPlayer
@onready var fire_point: Node3D = $FirePoint

var sensitivity := 0.06
var pitch := 0.0
var yaw := 0.0
var max_pitch := 20
var min_pitch := -20
var move_input: Vector3 = Vector3.ZERO
@export var move_speed := 5.0

@export var projectile: PackedScene 
@export var projectile_speed := 10     
const RAY_LENGTH := 1000                 

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _input(event):
	if event is InputEventMouseMotion:
		yaw -= event.relative.x * sensitivity
		rotation_degrees.y = yaw 
		pitch += event.relative.y * sensitivity
		pitch = clamp(pitch, min_pitch, max_pitch)
		head.rotation_degrees.x = pitch


func _process(delta):
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

	
#The following function performs a raycast from the origin to the direction
func check_aim_for_target(origin, direction):
	var end = origin + direction * RAY_LENGTH
	var query = PhysicsRayQueryParameters3D.create(origin, end)
	query.exclude = [self] 
	var result = get_world_3d().direct_space_state.intersect_ray(query)

	if result and result.collider:
		var collider = result.collider
		return result.position 

	return Vector3.INF
	
	
func shoot():
	var shoot_direction = -cam.global_transform.basis.z 
	var origin_point = cam.global_transform.origin 
	
	#Perform a raycast and get the value of their position
	var target_position = check_aim_for_target(origin_point, shoot_direction)
	
	#If the target position is not Vector3.INF, it indicates that there is a collision. Therefore,
	#we change the shoot_direction to aim towards that target position.
	if target_position != Vector3.INF:
		var fire_point_pos = fire_point.global_transform.origin
		shoot_direction = (target_position - fire_point_pos).normalized()
	
	#Launch the projectile
	var proj_instance = projectile.instantiate()
	get_tree().current_scene.add_child(proj_instance)
	var spawn_pos = fire_point.global_transform.origin
	proj_instance.global_transform.origin = spawn_pos
	proj_instance.look_at(spawn_pos + shoot_direction, Vector3.UP) 
	proj_instance.velocity = shoot_direction * projectile_speed
	
