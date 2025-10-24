extends ProgressBar

@onready var player = $".."
@onready var sprite: Sprite2D = player.get_node_or_null("Sprite2D")

func _ready() -> void:
	size = Vector2(50, 8)  # Default size 
	value = player.hp
	max_value = player.max_hp
	
	

func _process(delta: float) -> void:
	value = player.hp
	if sprite and sprite.texture:
		size.x = sprite.texture.get_width() * sprite.scale.x
		var y_offset = sprite.texture.get_height() * sprite.scale.y / 2 + 10
		position = Vector2(-size.x/2, y_offset)
