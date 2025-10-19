extends Node2D

#Source: https://www.youtube.com/watch?v=FV4JkwI4OF4
class_name TurnQueue

var active_character: Character #store the active character
var character_list

#for now, auto select the attacks. in the actual implementation, these would be loaded inside the character
#scenes i think
var slash_attack = preload('res://actions/slash_attack.gd')
var fireball = preload('res://actions/fireball.gd')

func initialize():
	character_list = get_children()
	character_list.sort_custom(sort_characters) #sort characters by speed, fastest first
	for char in character_list:
		move_child(char, get_child_count() - 1)
	active_character = get_child(0)
	
static func sort_characters(a,b):
	return a.speed > b.speed

#handles the current turn. 
#currently sets the target and action automatically.
#to manage the enemy to select / the action to pick, it would have to be handled in battle_scene
#and we would have to pass on some arguments to play_turn().
func play_turn():
	var action
	var target = get_child(1)
	if active_character.char_name == 'Fighter':
		action = slash_attack.new()
		target = get_child(0)
	else:
		action = fireball.new()
	await active_character.play_turn(target, action)
	var new_index = (active_character.get_index() + 1 ) % get_child_count()
	active_character = get_child(new_index) #sets the active character to the next character in the queue.

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
	
