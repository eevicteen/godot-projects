extends Area2D

@export var SPEED: float = 400
var dir: float
var spawn_pos: Vector2
var spawn_rot: float
var type: String
@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D
var source: Node = null  # to prevent hitting the shooter

func _ready() -> void:
	global_position = spawn_pos
	global_rotation = spawn_rot

	if anim_sprite:
		anim_sprite.animation = type
		anim_sprite.play()

func _process(delta: float) -> void:
	global_position += Vector2(0, SPEED).rotated(dir) * delta

	if not get_viewport_rect().grow(50).has_point(global_position):
		queue_free()
