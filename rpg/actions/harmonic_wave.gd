extends "res://actions/action.gd"
class_name HarmonicWave

@export var base_damage: int = 15

func _init():
	initialize("Harmonic Wave", "A resonant blast of sound that damages all enemies.", false)

func execute(source, target):
	if source.has_node("AnimatedSprite2D"):
		var sprite = source.get_node("AnimatedSprite2D")
		if sprite.sprite_frames.has_animation("harmonic_wave"):
			sprite.play("harmonic_wave")
			await sprite.animation_finished  # wait for animation to end
			sprite.play("default")  # go back to idle animation
		else:
			push_warning("Animation not found on " + source.char_name)
	else:
		push_warning("No AnimatedSprite2D found on " + source.char_name)
		
	var modified_damage = source.magic + base_damage
	target.take_damage(modified_damage)
