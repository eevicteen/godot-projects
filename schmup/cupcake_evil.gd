extends CharacterBody2D

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
	global_position += direction * speed * delta

	global_rotation += 1.0 * delta

	if not get_viewport_rect().grow(100).has_point(global_position):
		queue_free()

func take_damage(amount: int = 1) -> void:
	if health <= 0:
		return
	health -= amount
	flash_sprite()
	if health <= 0:
		die()
		

func die() -> void:
	if big_explosion_scene:
		var big_exp = big_explosion_scene.instantiate()
		big_exp.global_position = global_position
		main.add_child(big_exp)
	queue_free()

func _on_shoot_timer_timeout() -> void:
	if anim_sprite:
		anim_sprite.animation = "shoot"
		anim_sprite.play()

	var new_bullet = bullet_scene.instantiate()
	new_bullet.setup(global_position,Vector2.LEFT,self,4,1, 400, "cupcake_bullet") #col_layer = 4 col_mask = 1 speed = 400
	main.add_child(new_bullet)

	shoot_timer.start()
	
func flash_sprite(times = 3):
	var tween = create_tween()
	for i in range(times):
		tween.tween_property(anim_sprite, "modulate", Color(1,0,0), 0.1)
		tween.tween_property(anim_sprite, "modulate", Color(1,1,1), 0.1)	
