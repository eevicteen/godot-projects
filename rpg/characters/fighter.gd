extends "res://characters/character.gd"
func _ready() -> void:
	if healthbar: healthbar.position = Vector2(0,80)
