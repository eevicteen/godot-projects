extends CharacterBody2D

@export var speed := 10.0
var acceleration := 700.0
const max_speed = 300
const friction = 900

@onready var anim := $AgentAnimator/AnimatedSprite2D
@onready var idle_timer := $IdleTimer
@onready var jump_start_timer := $JumpStartTimer
@onready var tilemap = get_parent().get_node('CollisionTiles')

var is_idle:= false
var was_on_floor:= true

signal idle

func _ready() -> void:
	idle.connect(_on_idle)
	idle_timer.timeout.connect(_on_idle_timer_timeout)
	

func _physics_process(delta: float) -> void:
	# Apply gravity
	if not is_on_floor():
		velocity.y += 980 * delta  # gravity

	# Jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = -500
		anim.play("jump")

	# Horizontal movement
	var dir = Input.get_axis("ui_left", "ui_right")
	velocity.x += dir * acceleration * delta
	velocity.x = clamp(velocity.x, -1*max_speed, max_speed)
	if dir != 0:
		anim.flip_h = dir < 0
	else:
		if velocity.x > 0:
			velocity.x = max(velocity.x - friction*delta, 0)
		elif velocity.x < 0:
			velocity.x = min(velocity.x + friction*delta, 0)
			
	#Check for slow tile
	var tile_pos = tilemap.local_to_map(global_position) + Vector2i(0,1)
	print("local pos", position.x)
	var tile_data = tilemap.get_cell_tile_data(0, tile_pos,false)
	print("Tile Pos:", tile_pos, "Tile Data:", tile_data)
	if tile_data:
		var slow_v = tile_data.get_custom_data("SlowVx")
		print("SlowVx:", tile_data.get_custom_data("SlowVx"))
		if slow_v != 0: velocity.x = velocity.x * (slow_v) 
	
	# Move
	move_and_slide()

	# Animation state machine
	if not is_on_floor():
		if was_on_floor:
			anim.play("jump_start")
			jump_start_timer.start(0.1) 
			was_on_floor = false
		elif velocity.y < 0:
			if jump_start_timer.is_stopped():
				if anim.animation != "jump_up":
					anim.play("jump_up")
		else:
			if anim.animation != "jump_down":
				anim.play("jump_down")
	else:
		if not was_on_floor:
			anim.play('still')
			was_on_floor = true
		if abs(velocity.x) > 10:
			if anim.animation != "run":
				anim.play("run")
				is_idle = false
		else:
			if not is_idle:
				anim.play("still")
				is_idle = true
				idle.emit() #Start the idle timer when player is not moving

#Idle Timer Handlling
func _on_idle() -> void:
	idle_timer.start(3) #Start idle animation after 3 seconds

func _on_idle_timer_timeout() -> void:
	anim.play("idle")
