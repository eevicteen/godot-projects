extends Node3D

@onready var particles = $GPUParticles3D
@onready var timer = $Timer

func _ready():
	particles.restart()
	timer.start()
	
func _on_Timer_timeout():
	queue_free()
