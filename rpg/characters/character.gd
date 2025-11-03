extends Node2D
class_name Character

signal turn_finished
signal text_emitted(text: String)

# Character stats
@export var char_name: String = "Unnamed"
@export var max_hp: int = 100
@export var hp: int = 100
@export var strength: int = 5
@export var magic: int = 5
@export var speed: int = 10
@export var is_enemy: bool = false
@export var is_defending: bool = false

# Optional nodes
@onready var animator: AnimationPlayer = null
@onready var healthbar: ProgressBar = null
@onready var skills
@onready var sprite: AnimatedSprite2D = null

var charge_countdown = 0
var charged_action = null
var charged_target = null


func _ready() -> void:
	# Optional AnimationPlayer
	if has_node("AnimationPlayer"):
		animator = $AnimationPlayer
	
	if has_node("AnimatedSprite2D"):
		sprite = $AnimatedSprite2D

	# Optional HealthBar
	if has_node("HP Bar"):
		healthbar = $"HP Bar"
		healthbar.rect_position = Vector2(0, -40)
		healthbar.max_value = max_hp
		healthbar.value = hp
	add_to_group("characters")


# Turn execution
func play_turn(target, action) -> void:
	is_defending = false

	emit_signal("text_emitted", char_name + " is taking a turn...")
	if sprite:
		sprite.play(action.action_name)  
	
	if action.is_charge:
		if charge_countdown < action.charge_time:
			emit_signal("text_emitted", char_name + " is charging up...")
			emit_signal("text_emitted", str(action.charge_time - charge_countdown) + " turns left to charge")
			charge_countdown += 1
			charged_action = action
			charged_target = target
		else:
			action.execute(self, target)
			charged_action = null
			charge_countdown = 0
			charged_target = null
		return

	emit_signal("text_emitted", char_name + " is performing " + action.action_name)

	if animator:
		await move_forward()

	action.execute(self, target)

	await get_tree().create_timer(1.0).timeout
	emit_signal("text_emitted", char_name + " finished turn.")
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
	if is_defending: 
		amount = amount / 2
		emit_signal("text_emitted", char_name + " is defending! Damage is halved.")
	amount = max(0, amount)
	hp = clamp(hp - amount, 0, max_hp)
	emit_signal("text_emitted", char_name + " takes " + str(amount) + " damage. HP: " + str(hp))
	if healthbar:
		healthbar.value = hp
	if hp <= 0:
		die()

func defend():
	is_defending = true
	$Sprite2D.modulate = Color.SKY_BLUE
	

func die() -> void:
	emit_signal("text_emitted", char_name + " has fallen!")
	
