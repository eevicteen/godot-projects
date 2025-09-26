extends Area2D

@export var SPEED: float = 400
var direction: Vector2 = Vector2.LEFT
var source: Node = null

@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	if anim_sprite:
		anim_sprite.play()

func _process(delta: float) -> void:
	global_position += direction.normalized() * SPEED * delta

	if not get_viewport_rect().grow(50).has_point(global_position):
		queue_free()

func _on_area_entered(area: Area2D) -> void:
	if area == source:
		return
	if area.has_method("take_damage"):
		area.take_damage(1)
		queue_free()
