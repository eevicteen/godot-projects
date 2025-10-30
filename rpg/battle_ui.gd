extends CanvasLayer

@onready var main_panel: Control = $MainPanel
@onready var attack_panel: Control = $AttackPanel
@onready var target_panel: VBoxContainer = $TargetPanel
@onready var turn_queue: Node = $"../TurnQueue"

# Main action buttons
@onready var attack_button: Button = $MainPanel/Attack
@onready var heal_button: Button = $MainPanel/Heal

# Skill buttons
@onready var vocal_strike_button: Button = $AttackPanel/VocalStrike
@onready var high_note_button: Button = $AttackPanel/HighNoteBlast
@onready var harmonic_wave_button: Button = $AttackPanel/HarmonicWave
@onready var healing_melody_button: Button = $AttackPanel/HealingMelody

var selected_action = null
var selected_target = null
var current_player = null

func _ready():
	randomize()

	main_panel.visible = false
	attack_panel.visible = false
	target_panel.visible = false

	# Connect buttons
	attack_button.pressed.connect(_on_attack_pressed)
	heal_button.pressed.connect(_on_heal_pressed)

	vocal_strike_button.pressed.connect(_on_vocalstrike_pressed)
	high_note_button.pressed.connect(_on_highnoteblast_pressed)
	harmonic_wave_button.pressed.connect(_on_harmonicwave_pressed)
	healing_melody_button.pressed.connect(_on_healingmelody_pressed)

	if turn_queue.has_signal("player_turn_started"):
		turn_queue.connect("player_turn_started", Callable(self, "_on_player_turn"))

# === When it's a player's turn ===
func _on_player_turn(player):
	current_player = player
	main_panel.visible = true
	attack_panel.visible = false
	target_panel.visible = false

	attack_button.visible = true
	heal_button.visible = true  


func _on_attack_pressed():
	main_panel.visible = false
	attack_panel.visible = true
	_hide_all_skill_buttons()

	if current_player.char_name == "Fortissimo":
		vocal_strike_button.visible = true
		high_note_button.visible = true
	elif current_player.char_name == "Aria":
		harmonic_wave_button.visible = true
		healing_melody_button.visible = true
	else:
		print("Unknown character trying to attack.")

func _on_heal_pressed():
	# Hide panels since we’re acting immediately
	main_panel.visible = false
	attack_panel.visible = false
	target_panel.visible = false

	if current_player == null:
		print("No current player set.")
		return

	# Simple self-heal
	var heal_amount := 15
	current_player.hp = min(current_player.max_hp, current_player.hp + heal_amount)

	# Update HP bar if available
	if current_player.healthbar:
		current_player.healthbar.value = current_player.hp

	print("%s heals themself for %d HP!" %
		[current_player.char_name, heal_amount, current_player.hp, current_player.max_hp])

	# Optional short delay for pacing
	await get_tree().create_timer(0.6).timeout

	# Move to the next character’s turn
	turn_queue._next_turn()



func _on_vocalstrike_pressed():
	selected_action = preload("res://actions/vocal_strike.gd").new()
	attack_panel.visible = false
	_show_target_panel(false)

func _on_highnoteblast_pressed():
	selected_action = preload("res://actions/high_note.gd").new()
	attack_panel.visible = false
	_show_target_panel(false)

func _on_harmonicwave_pressed():
	selected_action = preload("res://actions/harmonic_wave.gd").new()
	attack_panel.visible = false
	_show_target_panel(false)

func _on_healingmelody_pressed():
	selected_action = preload("res://actions/healing_melody.gd").new()
	attack_panel.visible = false
	_show_target_panel(false)

# === Target selection ===
func _show_target_panel(is_heal: bool):
	target_panel.visible = true

	for child in target_panel.get_children():
		child.queue_free()

	for char in turn_queue.character_list:
		if char.hp > 0:
			# Healing = target allies; Attacking = target enemies
			if is_heal and char.char_name in ["Fortissimo", "Aria"]:
				_add_target_button(char)
			elif not is_heal and char.char_name not in ["Fortissimo", "Aria"]:
				_add_target_button(char)

func _add_target_button(char):
	var btn = Button.new()
	btn.text = char.char_name
	btn.pressed.connect(func():
		_on_target_selected(char)
	)
	target_panel.add_child(btn)

func _on_target_selected(target):
	target_panel.visible = false
	selected_target = target

	if selected_action and selected_target:
		await turn_queue.play_turn(selected_action, selected_target)
		selected_action = null
		selected_target = null

func _hide_all_skill_buttons():
	vocal_strike_button.visible = false
	high_note_button.visible = false
	harmonic_wave_button.visible = false
	healing_melody_button.visible = false
