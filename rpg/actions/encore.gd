extends "res://actions/action.gd"
class_name Encore

@export var base_damage: int = 4

func _init():
	initialize("Encore", "A repeated attack that hits one hero.")

func execute(source, target):
	# Ensure damage is at least 0
	var modified_damage = max(0, source.strength + base_damage)

	# Apply damage
	target.take_damage(modified_damage)
