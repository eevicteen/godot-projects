extends Resource
class_name HealAction

@export var action_name := "Heal"
@export var description := "Restore some HP"

@export var heal_amount := 5

func execute(source, target):
	target.hp = min(target.hp + heal_amount, target.max_hp)
	if target.healthbar:
		target.healthbar.value = target.hp
