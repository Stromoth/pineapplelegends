extends CharacterBody2D

const SPEED = 100.0
const JUMP_VELOCITY = -330.0

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var respawn_timer: Timer = $RespawnTimer  # cria um Timer no player e conecta depois
@onready var start_position: Vector2 = global_position

var dead = false

func _physics_process(delta: float) -> void:
	if dead:
		return

	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction := Input.get_axis("move_left", "move_right")
	
	if direction > 0:
		animated_sprite_2d.flip_h = false
	elif direction < 0:
		animated_sprite_2d.flip_h = true 
	
	if direction == 0:
		animated_sprite_2d.play("idle")
	else:
		animated_sprite_2d.play("walking")
	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	move_and_slide()

func die():
	if dead:
		return
	dead = true
	animated_sprite_2d.play("death")
	respawn_timer.start()

func _on_RespawnTimer_timeout():
	dead = false
	global_position = start_position
	animated_sprite_2d.play("respawn")
