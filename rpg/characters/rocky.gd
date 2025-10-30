extends Character

func _ready() -> void:
	if healthbar:
		healthbar.rect_position = Vector2(0, 40)
	char_name = "Rocky"
