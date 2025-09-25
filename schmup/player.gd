extends Area2D

const SPEED = 420
var health = 5
var test_counter = 1

var screen_size

func _ready():
	screen_size = get_viewport_rect().size

func _physics_process(delta: float) -> void:
	var velocity = Vector2.ZERO 
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
		
	if velocity.length() > 0:
		velocity = velocity.normalized() * SPEED #normalize it to prevent diagonal movement being faster
		#$AnimatedSprite2D.play()
	#else:
		#$AnimatedSprite2D.stop()
		
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	
	#if velocity.x != 0:
		#$AnimatedSprite2D.animation = "walk"
		#$AnimatedSprite2D.flip_v = false
		#$AnimatedSprite2D.flip_h = velocity.x < 0
	#elif velocity.y != 0:
		#$AnimatedSprite2D.animation = "up"
		#$AnimatedSprite2D.flip_v = velocity.y > 0	
	 
func _on_area_entered(area: Area2D) -> void:
	print('heeree')
	if area.is_in_group("mob"):
		print("Player takes damage from mob")
		health -= 1
	elif area.is_in_group("bullet"):
		print("Player takes damage from bullet")
		health -= 1 # Replace with function body.
