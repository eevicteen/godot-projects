extends Node2D

@onready var turn_queue: TurnQueue = $TurnQueue

var battle_active := true

func _ready() -> void:
	print("Battle starting...")
	turn_queue.initialize()
	await run_battle_loop()

func run_battle_loop() -> void:
	while battle_active:
		await turn_queue.play_turn()  # play a turn while the game is active

		if is_battle_over():
			battle_active = false
			break

	print("Battle ended!")
	show_results()

func is_battle_over() -> bool:
	# Simple win/lose check for now. if the number of alive characters is less than or equal to 1, then there
	# are no longer enemies to fight
	# proper implementation would have it check the number of dead enemies and dead heroes.
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
