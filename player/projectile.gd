extends Node3D

var velocity: Vector3
var speed := 0.0
var alive := true

@export var damage := 1
@export var small_explosion :PackedScene
@onready var mesh_instance := MeshInstance3D.new()

func setup(target_point: Vector3, p_speed: float):
	speed = p_speed
	velocity = (target_point - global_transform.origin).normalized() * speed
	look_at(global_transform.origin + velocity, Vector3.UP)

	mesh_instance.mesh = SphereMesh.new()
	mesh_instance.scale = Vector3(0.3, 0.3, 0.3)
	add_child(mesh_instance)

func _physics_process(delta: float) -> void:
	if not alive:
		return

	var move_vec = velocity * delta
	var from: Vector3 = global_transform.origin
	var to: Vector3 = from + move_vec * 1.05 

	# Short raycast to detect collision
	var space = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(from, to)
	query.exclude = [self]
	var result = space.intersect_ray(query)

	if result:
		var collider = result.collider
		var hit_position = result.position
		var hit_normal = result.normal
		
		if collider.has_method("take_damage"):
			collider.take_damage(damage, hit_position)
		var explosion = small_explosion.instantiate()
		explosion.global_transform.origin = hit_position + hit_normal * 0.1
		get_tree().current_scene.add_child(explosion)
		alive = false
		queue_free()
		return

	global_translate(move_vec)
