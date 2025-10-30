extends Node2D
class_name Character

signal turn_finished

# Character stats
@export var char_name: String = "Unnamed"
@export var max_hp: int = 100
@export var hp: int = 100
@export var strength: int = 5
@export var magic: int = 5
@export var speed: int = 10
@export var is_enemy: bool = false

# Optional nodes
@onready var animator: AnimationPlayer = null
@onready var healthbar: ProgressBar = null


func _ready() -> void:
	# Optional AnimationPlayer
	if has_node("AnimationPlayer"):
		animator = $AnimationPlayer

	# Optional HealthBar
	if has_node("HP Bar"):
		healthbar = $"HP Bar"
		healthbar.rect_position = Vector2(0, -40)
		healthbar.max_value = max_hp
		healthbar.value = hp


# Turn execution
func play_turn(target, action) -> void:
	print(char_name, " is taking a turn...")
	print(char_name, " is performing a ", action.action_name)

	# Move forward animation (optional)
	if animator:
		await move_forward()

	# Perform action
	action.execute(self, target)

	# Small delay to simulate attack
	await get_tree().create_timer(1.0).timeout

	# Move back animation (optional)
	if animator:
		await move_back()

	print(char_name, " finished turn.")
	emit_signal("turn_finished")


# Optional movement animations
func move_forward() -> void:
	if animator:
		animator.play("move_forward")
		await animator.animation_finished

func move_back() -> void:
	if animator:
		animator.play("move_back")
		await animator.animation_finished


# Damage handling
func take_damage(amount: int) -> void:
	amount = max(0, amount)
	hp = clamp(hp - amount, 0, max_hp)
	print(char_name, " takes ", amount, " damage. HP:", hp)
	if healthbar:
		healthbar.value = hp
	if hp <= 0:
		die()

func die() -> void:
	print(char_name, " has fallen!")
