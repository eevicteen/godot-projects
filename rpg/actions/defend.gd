extends "res://actions/action.gd"
class_name Defend

@export var base_damage: int = 10

func _init():
	initialize("Defend","Half the damage done in the next turn.")

func execute(source, target):
	source.defend()
