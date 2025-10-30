extends 'res://actions/action.gd'
class_name VocalStrike

@export var base_damage := 5

func execute(source, target):
	var modified_damage = source.magic + base_damage
	target.take_damage(modified_damage)
	print(source.char_name, " uses ", action_name, " on ", target.char_name, " for ", modified_damage, " damage!")

func _init():
	initialize('VocalStrike', 'A sharp vocal attack dealing damage to one enemy.')
