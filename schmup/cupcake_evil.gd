extends Area2D

@export var max_health: int = 3
@export var speed: float = 150
var health: int
var direction: Vector2 = Vector2.LEFT

@onready var bullet: PackedScene = load("res://Bullet.tscn")
@onready var big_explosion_scene: PackedScene = preload("res://BigExplosion.tscn")
@onready var main = get_node(".")  # parent node to add bullets to

func _ready() -> void:
	health = max_health
	$ShootTimer.start()

func take_damage(amount: int = 1) -> void:
	if health <= 0:
		return  # Already dead, ignore further damage

	health -= amount
	print("Enemy hit! Remaining health:", health)

	if health <= 0:
		die()

func die() -> void:
	print("Enemy died")
	# Spawn big explosion only once
	if big_explosion_scene:
		var big_exp = big_explosion_scene.instantiate()
		big_exp.global_position = global_position
		get_tree().current_scene.add_child(big_exp)

	queue_free()

func _process(delta: float) -> void:
	global_position += direction * speed * delta
	global_rotation += 1.0 * delta

	if not get_viewport_rect().grow(100).has_point(global_position):
		queue_free()

func _on_shoot_timer_timeout() -> void:
	$AnimatedSprite2D.animation = "shoot"
	$AnimatedSprite2D.play()
	var new_bullet = bullet.instantiate()
	new_bullet.dir = rotation
	new_bullet.spawn_pos = global_position
	new_bullet.type = "cupcake_bullet"  # must exist in bullet SpriteFrames
	new_bullet.source = self            # optional, prevent self-hit
	main.add_child(new_bullet)
	
	print("Bullet spawned at ", new_bullet.global_position)
	
	$ShootTimer.start()
