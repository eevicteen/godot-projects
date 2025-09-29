extends Area2D

@export var speed := 400
var direction: Vector2 = Vector2.LEFT
var source : Node
@onready var small_explosion_scene: PackedScene = preload("res://SmallExplosion.tscn")

@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	if anim_sprite:
		anim_sprite.play()

func _process(delta: float) -> void:
	position += direction.normalized() * speed * delta
	rotation += 0.02

	if not get_viewport_rect().grow(50).has_point(position):
		queue_free()

func _on_body_entered(body) -> void:
	print("Hit body:", body.name)
	if body == source: #prevent bullets hitting their owner
		return 
	if body.has_method("take_damage"):
		body.take_damage(1)
		queue_free()
		
	if body.is_in_group("mob"):
		print("Enemy hit!")
		var small_exp = small_explosion_scene.instantiate() 
		small_exp.position = position
		get_tree().current_scene.add_child(small_exp)

		queue_free()
		
func setup(pos: Vector2, dir: Vector2, src: Node, col_layer: int, col_mask: int, spd: float, sprite_name: String) -> void:
	position = pos
	direction = dir
	source = src
	self.collision_layer = col_layer
	self.collision_mask = col_mask
	speed = spd  
	call_deferred("_set_animation", sprite_name)

func _set_animation(sprite_name: String) -> void:
	if anim_sprite:
		anim_sprite.animation = sprite_name
		anim_sprite.play()
