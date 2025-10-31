extends Node2D
class_name TurnQueue

signal player_turn_started(active_player)

var active_character
var character_list = []
var char_index = 0

# === Initialization ===
func initialize():
	character_list = get_children()
	character_list.sort_custom(sort_descending)

	active_character = character_list[0]
		
	if active_character.char_name in ["Fortissimo", "Aria"]:
		print("▶ Player turn started for:", active_character.char_name)
		emit_signal("player_turn_started", active_character)
	else:
		_enemy_turn()
	

# === Sorting by speed (higher first) ===
func sort_descending(a, b):
	return a.speed > b.speed


# === Executes a turn ===
func play_turn(action, target) -> void:
	if active_character.hp <= 0:
		_next_turn()
		return

	await active_character.play_turn(target, action)
	_next_turn()

# === Move to next character ===
func _next_turn():

	char_index = (char_index+ 1) % get_child_count()	
	active_character = character_list[char_index]

	# --- PLAYER TURN LOGIC ---
	# Check if the active character is one of the player's party
	if active_character.char_name in ["Fortissimo", "Aria"]:
		print("▶ Player turn started for:", active_character.char_name)
		emit_signal("player_turn_started", active_character)
	else:
		_enemy_turn()

func _enemy_turn() -> void:
	var actions = active_character.skills

	var enemy_action = actions[randi() % actions.size()]

	# Find the weakest alive player
	var weakest_player: Node = null
	var lowest_hp = INF

	for char in character_list:
		if char.char_name in ["Fortissimo", "Aria"] and char.hp > 0:
			if char.hp < lowest_hp:
				lowest_hp = char.hp
				weakest_player = char

	if weakest_player:
		await play_turn(enemy_action, weakest_player)
