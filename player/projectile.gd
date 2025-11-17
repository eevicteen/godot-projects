extends Node3D

# Projectile settings
var velocity: Vector3
var speed := 0.0
var alive := true

@onready var mesh_instance := MeshInstance3D.new()

func setup(target_point: Vector3, p_speed: float):
	speed = p_speed
	velocity = (target_point - global_transform.origin).normalized() * speed

	# Orient projectile in direction of travel
	look_at(global_transform.origin + velocity, Vector3.UP)

	# Projectile mesh
	mesh_instance.mesh = SphereMesh.new()
	mesh_instance.scale = Vector3(0.3, 0.3, 0.3)
	add_child(mesh_instance)

func _physics_process(delta: float) -> void:
	if not alive:
		return

	var move_vec = velocity * delta
	var from: Vector3 = global_transform.origin
	var to: Vector3 = from + move_vec

	# Short raycast to detect collision
	var space = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(from, to)
	query.exclude = [self]
	var result = space.intersect_ray(query)

	if result:
		alive = false
		queue_free()
		return

	# Move projectile forward
	global_translate(move_vec)
