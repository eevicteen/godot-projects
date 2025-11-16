extends Node3D

const RAY_LENGTH = 1000
var _check_hit = false
var aim_cast_origin
var aim_casts_cam_ray_project
@onready var fire_origin = $FirePoint 

@onready var aim_cast = $AimCast
@onready var fire_cast = $FireCast

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _physics_process(delta:float):
	if _check_hit:
		_check_hit = false
		check_aim_hit()

func fire_shot(origin, cam_ray_project):
	print('fire shot')
	aim_cast_origin = origin
	aim_casts_cam_ray_project = cam_ray_project
	_check_hit = true

func check_aim_hit():
	print('check hit')

	var end = aim_cast_origin + aim_casts_cam_ray_project * RAY_LENGTH

	var query = PhysicsRayQueryParameters3D.create(aim_cast_origin, end)
	var result = get_world_3d().direct_space_state.intersect_ray(query)

	aim_cast.enabled = true
	aim_cast.global_position = aim_cast_origin

	aim_cast.target_position = aim_cast.to_local(end)
	aim_cast.force_raycast_update()

	if result && result.collider:
		print("Hit something")
		var collision_point = result.position
		print("Collision Point: ", collision_point)
		fire_cast.global_position = fire_origin.global_transform.origin
		fire_cast.target_position = fire_cast.to_local(collision_point)
		fire_cast.force_raycast_update()
		
		var from_gun_query = PhysicsRayQueryParameters3D.create(fire_origin.global_transform.origin, collision_point)
		var from_gun_result = get_world_3d().direct_space_state.intersect_ray(from_gun_query)

			
		
	
