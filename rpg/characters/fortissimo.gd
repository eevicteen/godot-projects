# Fortissimo.gd
extends "res://characters/character.gd"
class_name Fortissimo

func _ready():
	char_name = "Fortissimo"
	is_enemy = false
	hp = 100
	strength = 8
	speed = 10
	skills = [ preload("res://actions/vocal_strike.gd").new(),
	preload("res://actions/high_note.gd").new()]
	print(char_name, " ready for battle!")
	
