extends Area2D

@export var speed: float = 150
@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var shoot_timer: Timer = $ShootTimer
@onready var big_explosion_scene: PackedScene = preload("res://BigExplosion.tscn")

var direction: Vector2 = Vector2.LEFT

func _ready():
	print("Enemy spawned:", name, "at", global_position)
	shoot_timer.start()
	add_to_group("mob")
	$CollisionShape2D.disabled = false

func _physics_process(delta: float) -> void:
	position += direction * speed * delta
	if not get_viewport_rect().grow(100).has_point(global_position):
		queue_free()

func take_damage(amount: int = 1) -> void:
	die()

func die() -> void:
	print("Enemy died:", name)  # debug
	var big_exp = big_explosion_scene.instantiate() 
	big_exp.global_position = global_position
	get_tree().current_scene.add_child(big_exp)
	queue_free()
