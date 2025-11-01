extends "res://actions/action.gd"
class_name Concerto

@export var base_damage: int = 40
@export var charge_time: int = 2


func _init():
	is_charge = true
	action_name = "Concerto"
	description = "Charge a powerful attack for two turns before using it."

func execute(source, target):
	var modified_damage = source.magic + base_damage
	target.take_damage(modified_damage)
