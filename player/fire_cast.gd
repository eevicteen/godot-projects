extends Node3D

const RAY_LENGTH := 1000
@export var small_explosion: PackedScene

func fire_shot(origin: Vector3, direction: Vector3):
	var end = origin + direction * RAY_LENGTH

	var query = PhysicsRayQueryParameters3D.create(origin, end)
	query.exclude = [get_parent()]  

	var result = get_world_3d().direct_space_state.intersect_ray(query)

	if result and result.collider:
		print("Hit:", result.collider.name)

		if result.collider.has_method("take_damage"):
			result.collider.take_damage(1, result.position)

		# Spawn small explosion at hit point for other objects
		elif small_explosion:
			var explosion = small_explosion.instantiate()
			explosion.global_transform.origin = result.position + result.normal * 0.1
			get_tree().current_scene.add_child(explosion)
			print("Spawning small explosion at: ", explosion.global_transform.origin)
