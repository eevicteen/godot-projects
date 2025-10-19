extends 'res://actions/action.gd'

@export var base_damage := 5

func execute(source, target):
	var modified_damage = source.magic + base_damage
	target.take_damage(modified_damage)

func _init():
	initialize('Fireball', 'Deal 5 Magic damage to One enemy.')
