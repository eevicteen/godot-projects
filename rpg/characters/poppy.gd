extends "res://characters/character.gd"

class_name Poppy

func _ready() -> void:
	if healthbar:
		healthbar.rect_position = Vector2(0, 40)
	hp = 70
	max_hp = 70
	strength = 10
	speed = 2
	char_name = "Poppy"
	skills=[preload("res://actions/power_chord.gd").new(),
	preload("res://actions/encore.gd").new(),
	preload("res://actions/defend.gd").new()]
	print(char_name, " ready for battle!")
