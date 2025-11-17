extends Node3D

# Enemy Stats
@export var max_hp := 4  
var hp := max_hp

# Explosion Scenes
@export var big_explosion: PackedScene   
@export var small_explosion: PackedScene
	

func take_damage(amount: int = 1, hit_pos: Vector3 = Vector3.ZERO):
	hp -= amount
	print("Enemy hit! HP left:", hp)

	var spawn_pos := hit_pos
	if spawn_pos == Vector3.ZERO:
		spawn_pos = global_transform.origin + Vector3.UP * 1.0  

	# Spawn small explosion when enemy is still alive
	if hp > 0:
		if small_explosion:
			var explosion = small_explosion.instantiate()
			get_tree().current_scene.add_child(explosion)
			explosion.global_transform.origin = spawn_pos + Vector3.UP * 1.0
			print("Spawning small explosion at: ", spawn_pos)

	if hp <= 0:
		die()

func die():
	if big_explosion:
		var explosion = big_explosion.instantiate()
		get_tree().current_scene.add_child(explosion)
		explosion.global_transform.origin = global_transform.origin + Vector3.UP * 0.1

	# Remove enemy after spawning explosion
	queue_free()
