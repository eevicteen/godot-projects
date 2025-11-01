extends Node2D

@onready var turn_queue: TurnQueue = $TurnQueue
var battle_active := true
var alive_heroes = []
var alive_enemies = []

func _ready() -> void:
	await get_tree().create_timer(1.0).timeout
	print("Battle starting...")
	
	turn_queue.initialize()
	turn_queue.connect("turn_finished", Callable(self, "_on_turn_finished"))
	
	print("Battle in progress...")

func _on_turn_finished():
	if is_battle_over():
		battle_active = false
		print("Battle ended!")
		turn_queue.battle_active = false
		show_results()
	else:
		print("Continuing battle...")

func is_battle_over() -> bool:
	alive_heroes.clear()
	alive_enemies.clear()
	for char in turn_queue.character_list:
		if char.hp > 0 and char.is_enemy:
			alive_enemies.append(char)
		elif char.hp > 0 and !char.is_enemy:
			alive_heroes.append(char)
	return alive_heroes.is_empty() or alive_enemies.is_empty()

func show_results() -> void:
	if alive_heroes.is_empty():
		print("The enemies won!")
	else:
		print("The heroes won!")
