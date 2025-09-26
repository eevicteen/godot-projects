extends Node2D  # or Area2D if you want collision

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

func _ready():
	anim.play()

func _on_AnimatedSprite2D_animation_finished():
	queue_free()
