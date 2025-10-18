extends Node2D

#Source: https://www.youtube.com/watch?v=FV4JkwI4OF4
class_name TurnQueue

var active_character: Character #store the active character
var character_list

func initialize():
	character_list = get_children()
	character_list.sort_custom(self, 'sort_characters') #sort characters by speed, fastest first
	for char in character_list:
		char.raise()
	active_character = get_child(0)
	
static func sort_characters(a,b):
	return a.speed > b.speed

func play_turn():
	await active_character.play_turn();"completed"
	var new_index = (active_character.get_index() + 1 ) % get_child_count()
	active_character = get_child(new_index)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
	
