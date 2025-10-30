extends "res://actions/action.gd"
class_name HighNoteBlast

@export var base_damage: int = 8

func _init():
	initialize("HighNoteBlast", "A powerful high note that deals extra magic damage.")

func execute(source, target):
	var modified_damage = source.magic + base_damage
	target.take_damage(modified_damage)
	print(source.char_name, " uses ", action_name, " on ", target.char_name, " for ", modified_damage, " damage!")
