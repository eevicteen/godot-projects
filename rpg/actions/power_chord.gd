extends "res://actions/action.gd"
class_name PowerChord

@export var base_damage: int = 6  # adjust as needed

func _init():
	initialize("Power Chord", "A powerful rock attack that hits one hero.")

func execute(source, target):
	# Ensure damage is at least 0
	var modified_damage = max(0, source.strength + base_damage)

	# Apply damage
	target.take_damage(modified_damage)
