extends Node3D

var velocity: Vector3
var speed := 0.0
var alive := true

func setup(target_point: Vector3, p_speed: float):
	speed = p_speed
	velocity = (target_point - global_transform.origin).normalized() * speed

	# Orient projectile in direction of travel
	look_at(global_transform.origin + velocity, Vector3.UP)

func _physics_process(delta: float) -> void:
	if not alive:
		return

	var move_vec = velocity * delta
	var from: Vector3 = global_transform.origin
	var to: Vector3 = from + move_vec

	# Raycast short segment to avoid tunneling
	var space = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(from, to)
	var result = space.intersect_ray(query)

	if result:
		alive = false
		queue_free()
		return

	# Move forward
	translate(move_vec)
