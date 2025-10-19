extends 'res://actions/action.gd'

@export var base_damage := 5

func execute(source, target):
	var modified_damage = source.strength + base_damage
	target.take_damage(modified_damage)

func _init():
	initialize('Slash Attack', 'Deal 5 Physical damage to One enemy.')
