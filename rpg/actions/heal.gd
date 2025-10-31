extends Resource
class_name HealAction

@export var action_name := "Heal"
@export var description := "Restore some HP"

@export var heal_amount := 5

func execute(source, target):
	source.hp = min(source.hp + heal_amount, source.max_hp)
	if source.healthbar:
		source.healthbar.value = source.hp
