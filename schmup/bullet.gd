extends Area2D

var dir: float
var spawn_pos: Vector2
var spawn_rot: float
var type: String
const SPEED:= 400
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	global_position = spawn_pos
	global_rotation = spawn_rot
	$AnimatedSprite2D.animation = type


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position += Vector2(0,SPEED).rotated(dir)*delta


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
