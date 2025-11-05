extends CharacterBody2D

const SPEED = 100.0
const JUMP_VELOCITY = -330.0

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var respawn_timer: Timer = $RespawnTimer
@onready var start_position: Vector2 = global_position

var dead = false
var in_car = false

func _ready() -> void:
	# conecta sinais por código (pode conectar no editor se preferir)
	if respawn_timer:
		respawn_timer.timeout.connect(_on_RespawnTimer_timeout)
	if animated_sprite_2d:
		# sinal chamado quando qualquer animação terminar
		animated_sprite_2d.animation_finished.connect(_on_AnimatedSprite2D_animation_finished)

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
	print("die() called")
	animated_sprite_2d.play("death")
	# quando a animação "death" terminar, o player continuará morto até o respawn_timer timeout
	respawn_timer.start()

func _on_RespawnTimer_timeout() -> void:
	print("respawn timer timeout")
	global_position = start_position
	animated_sprite_2d.play("respawn")

func _on_AnimatedSprite2D_animation_finished(anim_name: String) -> void:
	# esse callback é chamado para qualquer animação; checamos se foi a de respawn
	# dependendo da versão do Godot, o sinal pode passar o nome da animação ou não.
	# por segurança verificamos a propriedade current animation também.
	var current_anim := ""
	if animated_sprite_2d.has_method("get_animation"):
		current_anim = animated_sprite_2d.get_animation() # Godot 4?
	else:
		# Godot 3/compat fallback
		if "animation" in animated_sprite_2d:
			current_anim = animated_sprite_2d.animation
	# se a versão do engine te passar o anim_name por parâmetro, priorize-o:
	if anim_name != null and str(anim_name) != "":
		current_anim = str(anim_name)

	# debug
	print("animation_finished:", current_anim)

	if current_anim == "respawn":
		dead = false
		print("respawn finished -> freed controls")
