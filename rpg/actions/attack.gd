extends "res://actions/action.gd"
class_name Attack

@export var base_damage: int = 5

func _init():
	initialize("Attack", "Strike the enemy.")

func execute(source, target):
	var modified_damage = max(0, source.strength + base_damage)

	# Apply damage
	target.take_damage(modified_damage)
		
