extends Area2D

@export var speed: float = 600
var direction: Vector2 = Vector2.RIGHT
var source: Node = null
@onready var small_explosion_scene: PackedScene = preload("res://SmallExplosion.tscn")

func _ready() -> void:
	if not is_connected("area_entered", Callable(self, "_on_area_entered")):
		connect("area_entered", Callable(self, "_on_area_entered"))

func _physics_process(delta: float) -> void:
	position += direction.normalized() * speed * delta
	if not get_viewport_rect().grow(50).has_point(global_position):
		queue_free()

func _on_area_entered(area: Area2D) -> void:
	if area == source:
		return 

	if area.is_in_group("mob"):
		print("Enemy hit!")
		var small_exp = small_explosion_scene.instantiate() 
		small_exp.global_position = global_position
		get_tree().current_scene.add_child(small_exp)

		area.take_damage(1)

		queue_free()
