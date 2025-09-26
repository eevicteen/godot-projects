extends Node2D

@export var enemy_scene: PackedScene
@export var spawn_rate: float = 2.0

@onready var timer: Timer = $Timer

func _ready():
	timer.wait_time = spawn_rate
	timer.start()
	timer.timeout.connect(Callable(self, "_on_timer_timeout"))

func _on_timer_timeout() -> void:
	if enemy_scene:
		var enemy = enemy_scene.instantiate() as Area2D
		var screen_size = get_viewport_rect().size
		enemy.position.x = screen_size.x + 50
		enemy.position.y = randf_range(0, screen_size.y)
		get_tree().current_scene.add_child(enemy)
		print("Enemy spawned at:", global_position)  # debug
	else:
		print("No enemy scene assigned!")  # debug
