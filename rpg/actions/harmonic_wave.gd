extends "res://actions/action.gd"
class_name HarmonicWave

@export var base_heal: int = 12

func _init():
	initialize("Harmonic Wave", "A soothing wave that heals an ally.",true)

func execute(source, target):
	var heal_amount = source.magic + base_heal
	target.hp = min(target.max_hp, target.hp + heal_amount)
	print(target.char_name, " healed for ", heal_amount, " HP!")

	if target.healthbar:
		target.healthbar.value = target.hp
