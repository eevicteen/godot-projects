extends Area2D

@export var max_health: int = 3
@export var speed: float = 150
var health: int
var direction: Vector2 = Vector2.LEFT

@onready var bullet_scene: PackedScene = preload("res://Bullet.tscn")
@onready var main = get_tree().current_scene
@onready var shoot_timer: Timer = $ShootTimer
@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var big_explosion_scene: PackedScene = preload("res://BigExplosion.tscn")

func _ready() -> void:
	health = max_health
	shoot_timer.start()

func _process(delta: float) -> void:
	# Move left
	global_position += direction * speed * delta

	# Rotate the enemy visually
	global_rotation += 1.0 * delta

	# Remove off-screen
	if not get_viewport_rect().grow(100).has_point(global_position):
		queue_free()

func take_damage(amount: int = 1) -> void:
	if health <= 0:
		return
	health -= amount
	if health <= 0:
		die()

func die() -> void:
	if big_explosion_scene:
		var big_exp = big_explosion_scene.instantiate()
		big_exp.global_position = global_position
		main.add_child(big_exp)
	queue_free()

func _on_shoot_timer_timeout() -> void:
	# Play shoot animation
	if anim_sprite:
		anim_sprite.animation = "shoot"
		anim_sprite.play()

	# Spawn bullet flying straight
	var new_bullet = bullet_scene.instantiate()
	new_bullet.global_position = global_position  # set position directly
	new_bullet.direction = Vector2.LEFT  # straight left
	new_bullet.source = self
	main.add_child(new_bullet)

	shoot_timer.start()
