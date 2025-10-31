extends "res://actions/action.gd"
class_name HealingMelody

@export var base_damage: int = 10

func _init():
	initialize("Roaring Melody", "A melodic attack that damages an enemy with sonic waves.")

func execute(source, target):
	var modified_damage = source.magic + base_damage
	target.take_damage(modified_damage)
