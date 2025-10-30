extends "res://actions/action.gd"
class_name HealingMelody

@export var base_damage: int = 10

func _init():
	initialize("Healing Melody", "A melodic attack that damages an enemy with sonic waves.")

func execute(source, target):
	var modified_damage = max(0, source.magic - base_damage)
	target.take_damage(modified_damage)
	
	print("%s uses %s on %s for %d damage!" % [
		source.char_name,
		action_name,
		target.char_name,
		modified_damage
	])
