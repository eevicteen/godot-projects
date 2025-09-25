extends Area2D

@onready var bullet = load("res://bullet.tscn")
@onready var main = get_node(".")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$ShootTimer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_rotation += 0.05*delta

func _on_shoot_timer_timeout() -> void:
	$AnimatedSprite2D.animation = "shoot"
	$AnimatedSprite2D.play()
	
	
func _on_animated_sprite_2d_animation_finished() -> void:
	var cupcake_bullet = bullet.instantiate()
	cupcake_bullet.dir = rotation
	cupcake_bullet.spawn_pos = global_position
	cupcake_bullet.spawn_rot = global_rotation
	cupcake_bullet.type = "cupcake_bullet"
	main.add_child(cupcake_bullet)
	$ShootTimer.start()
