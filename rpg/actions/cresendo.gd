extends "res://actions/action.gd"
class_name Cresendo

@export var buff_amount: int = 5

func _init():
	initialize("Cresendo", "A gradually increasing tune that boosts an ally's strength temporarily.",true)

func execute(source, target):
	target.strength += buff_amount
	print("%s uses %s on %s! %s's strength increased by %d!" %
		[source.char_name, action_name, target.char_name, target.char_name, buff_amount])
