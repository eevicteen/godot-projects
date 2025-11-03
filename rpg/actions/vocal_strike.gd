extends 'res://actions/action.gd'
class_name VocalStrike

@export var base_damage := 5

func _init():
	initialize('Vocal Strike', 'A sharp vocal attack dealing damage to one enemy.')
	
func execute(source, target):
	# Play animation
	if source.has_node("AnimatedSprite2D"):
		var sprite = source.get_node("AnimatedSprite2D")
		if sprite.sprite_frames.has_animation("vocal_strike"):  # make sure animation exists
			sprite.play("vocal_strike")
			await sprite.animation_finished  # wait for animation to end
			if sprite.sprite_frames.has_animation("default"):
				sprite.play("default")  # go back to idle animation
		else:
			push_warning("Animation 'roaring_melody' not found on " + source.char_name)
	else:
		push_warning("No AnimatedSprite2D found on " + source.char_name)

	# Deal damage
	var damage_amount = source.magic + base_damage
	target.hp = max(0, target.hp - damage_amount)
	print(target.char_name, " took ", damage_amount, " damage!")

	# Update healthbar
	if target.healthbar:
		target.healthbar.value = target.hp
