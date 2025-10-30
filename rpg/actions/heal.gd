extends Resource
class_name HealAction

@export var action_name := "Heal"
@export var description := "Restore some HP"

@export var heal_amount := 10

func execute(source, target):
	target.hp = min(target.hp + heal_amount, target.max_hp)
	if target.healthbar:
		target.healthbar.value = target.hp
	print("%s uses Heal on %s for %d HP!" % [source.char_name, target.char_name, heal_amount])
