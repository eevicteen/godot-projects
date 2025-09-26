extends CharacterBody2D

const SPEED: float = 420
var max_health: int = 10
var health: int = max_health
var facing_dir: Vector2 = Vector2.RIGHT

@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var bullet_scene: PackedScene = preload("res://player_bullet.tscn")
@onready var health_bar_wrapper: Node2D = $HealthBarWrapper
@onready var health_bar: ProgressBar = $HealthBarWrapper/ProgressBar
var screen_size: Vector2
		
func _ready() -> void:
	screen_size = get_viewport_rect().size
	if health_bar_wrapper:
		health_bar_wrapper.global_position = Vector2(0, -40)
	update_health_bar()

func _physics_process(delta: float) -> void:
	var input_vector = Vector2.ZERO

	# --- Movement ---
	if Input.is_action_pressed("ui_right"):
		input_vector.x += 1
	if Input.is_action_pressed("ui_left"):
		input_vector.x -= 1
	if Input.is_action_pressed("ui_down"):
		input_vector.y += 1
	if Input.is_action_pressed("ui_up"):
		input_vector.y -= 1

	if input_vector.length() > 0:
		input_vector = input_vector.normalized() * SPEED
		velocity = input_vector
		facing_dir = input_vector.normalized()
		anim_sprite.play()
	else:
		velocity = Vector2.ZERO
		anim_sprite.stop()

	move_and_slide()

	# --- Animation flipping ---
	if input_vector.x != 0:
		anim_sprite.animation = "run"
		anim_sprite.flip_h = input_vector.x < 0
	elif input_vector.y < 0:
		anim_sprite.animation = "up"
	elif input_vector.y > 0:
		anim_sprite.animation = "down"

	# --- Shooting ---
	if Input.is_action_just_pressed("shoot"):
		shoot()


# ---------------------------
func shoot() -> void:
	var bullet = bullet_scene.instantiate() 
	bullet.global_position = global_position
	bullet.direction = facing_dir
	bullet.source = self
	get_tree().current_scene.add_child(bullet)
	print("Bullet fired!")

func take_damage(amount: int = 1) -> void:
	health -= amount
	print("Player hit! Remaining health:", health)
	update_health_bar()
	if health <= 0:
		die()

func update_health_bar() -> void:
	if health_bar:
		health_bar.max_value = max_health
		health_bar.value = health

func die() -> void:
	print("Player died!")
	# You can play a death animation or trigger game over
	queue_free()
