extends CharacterBody3D

@export var health := 3

func take_damage(amount):
	health -= amount
	if health <= 0:
		explode()

func explode():
	# Spawn explosion effect here
	queue_free()
