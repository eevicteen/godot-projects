extends "res://actions/action.gd"
class_name HealAction

@export var heal_amount := 5

func _init():
	action_name = "Heal"
	description = "Restore some HP"
	
func execute(source, target):
	source.hp = min(source.hp + heal_amount, source.max_hp)
	if source.healthbar:
		source.healthbar.value = source.hp
