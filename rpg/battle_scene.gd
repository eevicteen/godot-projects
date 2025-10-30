extends Node2D

@onready var turn_queue: TurnQueue = $TurnQueue
var selected_action = null
var selected_target = null
var battle_active := true

func _ready() -> void:
	await get_tree().create_timer(1.0).timeout
	print("Battle starting...")
	turn_queue.initialize()
	await run_battle_loop()

func run_battle_loop() -> void:
	while battle_active:
		# Wait until player has selected action and target
		if selected_action != null and selected_target != null:
			# Play the turn asynchronously
			await turn_queue.play_turn(selected_action, selected_target)

			# Reset selections for the next turn
			selected_action = null
			selected_target = null

			# Check for battle end
			if is_battle_over():
				battle_active = false
				break
		else:
			# Wait a tiny bit to prevent freezing while waiting for input
			await get_tree().process_frame

	print("Battle ended!")
	show_results()

func is_battle_over() -> bool:
	var alive_characters = []
	for char in turn_queue.character_list:
		if char.hp > 0:
			alive_characters.append(char)

	if alive_characters.size() <= 1:
		return true
	return false

func show_results() -> void:
	print("Battle Results:")
	for char in turn_queue.character_list:
		print(char.char_name, "HP:", char.hp)
