extends CharacterBody2D

const SPEED: float = 420
var max_health: int = 10
var health: int = max_health
var facing_dir: Vector2 = Vector2.RIGHT
var invin_tween = null

var can_shoot = true
var can_take_damage = true

@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var bullet_scene: PackedScene = preload("res://Bullet.tscn")
@onready var health_bar_wrapper: Node2D = $HealthBarWrapper
@onready var health_bar: ProgressBar = $HealthBarWrapper/ProgressBar
@onready var invin_timer = $InvincibilityTimer
@onready var shoot_delay_timer = $ShootDelayTimer
var screen_size: Vector2
		
func _ready() -> void:
	screen_size = get_viewport_rect().size
	if health_bar_wrapper:
		health_bar_wrapper.global_position = Vector2(0, -40)
	update_health_bar()

func _physics_process(delta: float) -> void:
	#Take in input vector
	var input_vector = Vector2.ZERO
	if Input.is_action_pressed("ui_right"):
		input_vector.x += 1
	if Input.is_action_pressed("ui_left"):
		input_vector.x -= 1
	if Input.is_action_pressed("ui_down"):
		input_vector.y += 1
	if Input.is_action_pressed("ui_up"):
		input_vector.y -= 1
		
	#Normalize Input vector and Animate
	if input_vector.length() > 0:
		input_vector = input_vector.normalized() * SPEED
		velocity = input_vector
		facing_dir = input_vector.normalized()
		anim_sprite.play()
	else:
		velocity = Vector2.ZERO
		anim_sprite.stop()
		
	move_and_slide()
	
	
	#Change Animation Sprite
	if input_vector.x != 0:
		anim_sprite.animation = "run"
		anim_sprite.flip_h = input_vector.x < 0
	elif input_vector.y < 0:
		anim_sprite.animation = "up"
	elif input_vector.y > 0:
		anim_sprite.animation = "down"

	if Input.is_action_pressed("shoot"):
		shoot()
		
	#Handle Player-Enemy Collision
	if can_take_damage:
		for i in get_slide_collision_count():
			var collision = get_slide_collision(i)
			var collider = collision.get_collider()
			if collider.has_method("take_damage"):
				self.take_damage(1)
				collision.get_collider().take_damage(1)


func shoot() -> void:
	if can_shoot:
		var bullet = bullet_scene.instantiate() 
		bullet.setup(global_position,facing_dir,self,1<<1,1<<2,600,"player_bullet") #col_layer = 2, col_mask = 3, speed = 600
		get_tree().current_scene.add_child(bullet)
		shoot_delay_timer.start()
	can_shoot = false


func take_damage(amount: int = 1) -> void:
	if can_take_damage:
		health -= amount
		print("Player hit! Remaining health:", health)
		update_health_bar()
		flash_sprite()
		if health <= 0:
			game_over()
		invin_timer.start()
		can_take_damage = false


func update_health_bar() -> void:
	if health_bar:
		health_bar.max_value = max_health
		health_bar.value = health

func game_over():
	# optional: prevent multiple calls
	can_take_damage = false
	can_shoot = false
	anim_sprite.stop()
	
	# switch to the Game Over scene
	get_tree().call_deferred("change_scene_to_file", "res://game_over.tscn")

#func die() -> void:
	#print("Player died!")
	#queue_free()
	#game_over()


func _on_invincibility_timer_timeout() -> void:
	can_take_damage = true
	invin_tween.tween_property(anim_sprite, "modulate", Color(1,1,1), 0.1)	
	invin_tween.kill()


func flash_sprite(times = 10):
	invin_tween = create_tween()
	for i in range(times):
		invin_tween.tween_property(anim_sprite, "modulate", Color(1,0,0), 0.1)
		invin_tween.tween_property(anim_sprite, "modulate", Color(1,1,1), 0.1)	


func _on_shoot_delay_timer_timeout() -> void:
	can_shoot = true
