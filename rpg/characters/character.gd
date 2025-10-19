extends Node2D
class_name Character

signal turn_finished

@export var char_name: String = "Unnamed"
@export var max_hp: int = 20
@export var hp: int = 20
@export var strength: int = 5 #used to calculate damage for physical type attacks
@export var magic: int = 5 #used to calculate damage for magic type attacks
@export var speed: int = 10 #determines turn order. higher speed means you go first.

@onready var animator: AnimationPlayer = $AnimationPlayer

#currently, move_forward and move_back are disabled (they are animations)
func play_turn(target, action) -> void:
	print(char_name, " is taking a turn...")
	print(char_name, " is performing a ", action.action_name)

	# Move forward animation
	#await move_forward()

	# Perform action
	action.execute(self, target)

	# Small delay (simulates attack time)
	await get_tree().create_timer(1.0).timeout

	# Move back animation
	#await move_back()

	print(char_name, " finished turn.")
	emit_signal(" turn_finished")

func move_forward() -> void:
	animator.play("move_forward")
	await animator.animation_finished

func move_back() -> void:
	animator.play("move_back")
	await animator.animation_finished

func take_damage(amount: int) -> void:
	hp = max(hp - amount, 0)
	print(char_name, " takes ", amount, " damage. HP:", hp)
	if hp <= 0:
		die()

func die() -> void:
	print(char_name, " has fallen!")
