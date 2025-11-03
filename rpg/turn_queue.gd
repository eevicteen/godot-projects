extends Node2D
class_name TurnQueue
@export var turn_log_label: RichTextLabel

signal player_turn_started(active_player)
signal turn_finished


var active_character
var character_list = []
var char_index = 0
var turn_count = 1
var battle_active 
var planned_actions = []

# === Initialization ===
func initialize():
	character_list = get_children()
	character_list.sort_custom(sort_descending)
	battle_active = true

	_new_turn()

func _new_turn():
	var to_remove = []
	for char in character_list:
		if char.hp <= 0:
			to_remove.append(char)

	for dead_char in to_remove:
		character_list.erase(dead_char)
		dead_char.queue_free()
	
	if not battle_active:
		return
	
	if char_index >= len(character_list):
		char_index = 0
	active_character = character_list[char_index]
	planned_actions = []
	print("Turn ", turn_count, " ------------------------")
	_choose_next_turn()
	
# === Sorting by speed (higher first) ===
func sort_descending(a, b):
	return a.speed > b.speed

# === Executes a turn ===
func play_turn() -> void:
	for act in planned_actions:
		var source = act[0]
		var action = act[1]
		var target = act[2]
		
		if source.hp <= 0:
			continue
			
		if target.hp <= 0 or target == null:
			print(source.char_name, " tried to perform ", action.action_name, " on ", target.char_name, "! But it failed..")
			continue
			
		await source.play_turn(target,action)
	
	
	turn_count += 1
	emit_signal('turn_finished')
	_new_turn()


# === Move to next character ===
func _next_turn():
	char_index += 1
	if char_index == len(character_list):
		play_turn()
	else:	
		char_index = char_index % len(character_list)	
		active_character = character_list[char_index]
		
		_choose_next_turn()

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

	planned_actions.append([active_character,enemy_action, weakest_player])
	_next_turn()
		
func player_turn(action,target):
	planned_actions.append([active_character, action, target])
	_next_turn()

func _choose_next_turn():
	if active_character.charged_action:
		planned_actions.append([active_character,active_character.charged_action,active_character.charged_target])
		_next_turn()
		return

	if active_character.char_name in ["Fortissimo", "Aria"]:
		log_message("Choosing action for: " + active_character.char_name)
		emit_signal("player_turn_started", active_character)
	else:
		_enemy_turn()


func log_message(text: String):
	if turn_log_label:
		turn_log_label.text = text
	else:
		print(text)
