extends CanvasLayer

@onready var main_panel: Control = $MainPanel
@onready var attack_panel: Control = $AttackPanel
@onready var target_panel: Control = $TargetPanel
@onready var turn_queue: Node = $"../TurnQueue"

# Main action buttons
@onready var attack_button: Button = $MainPanel/Attack
@onready var heal_button: Button = $MainPanel/Heal
@onready var defend_button: Button = $MainPanel/Defend

var selected_action = null
var selected_target = null
var current_player = null

var is_heal := false

func _ready():
	randomize()

	main_panel.visible = false
	attack_panel.visible = false
	target_panel.visible = false

	# Connect buttons
	attack_button.pressed.connect(_on_attack_pressed)
	heal_button.pressed.connect(_on_heal_pressed)
	defend_button.pressed.connect(_on_defend_pressed)

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
	
	#Clear the attack panel
	for child in attack_panel.get_children():
		child.queue_free()
		
	#Construct skill buttons dynamically
	for skill in current_player.skills:
		var btn = Button.new()
		btn.text = skill.action_name
		btn.pressed.connect(
			func():
				_on_skill_selected(skill)
		)
		attack_panel.add_child(btn)

func _on_heal_pressed():
	# Hide panels since we’re acting immediately
	main_panel.visible = false
	attack_panel.visible = false
	target_panel.visible = false

	if current_player == null:
		print("No current player set.")
		return

	# Simple self-heal
	var heal_amount := 5
	current_player.hp = min(current_player.max_hp, current_player.hp + heal_amount)

	# Update HP bar if available
	if current_player.healthbar:
		current_player.healthbar.value = current_player.hp

	print("%s heals themself for %d HP!" %
		[current_player.char_name, heal_amount])

	# Optional short delay for pacing
	await get_tree().create_timer(0.6).timeout

	# Move to the next character’s turn
	turn_queue._next_turn()

func _on_defend_pressed():
	# Hide panels since we’re acting immediately
	main_panel.visible = false
	attack_panel.visible = false
	target_panel.visible = false
	
	current_player.defend()
	print("%s defends!" %
		[current_player.char_name])
		
	# Optional short delay for pacing
	await get_tree().create_timer(0.6).timeout
	
	turn_queue._next_turn()

func _on_skill_selected(skill):
	selected_action = skill
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
			if selected_action.is_heal and char.char_name in ["Fortissimo", "Aria"]:
				_add_target_button(char)
			elif not selected_action.is_heal and char.char_name not in ["Fortissimo", "Aria"]:
				_add_target_button(char)

func _add_target_button(char):
	var btn = Button.new()
	btn.text = char.char_name
	btn.pressed.connect(func():
		_on_target_selected(char)
	)
	
	#place the target button above the character sprite
	await get_tree().process_frame
	var sprite = char.get_node("Sprite2D")
	var sprite_height = sprite.texture.get_size().y * sprite.scale.y
	var btn_length = len(btn.text)*10
	btn.position = char.global_position - Vector2(btn_length/2, sprite_height / 2 + 20)
	
	target_panel.add_child(btn)
	

func _on_target_selected(target):
	target_panel.visible = false
	selected_target = target

	if selected_action and selected_target:
		await turn_queue.play_turn(selected_action, selected_target)
		selected_action = null
		selected_target = null
