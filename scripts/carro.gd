extends CharacterBody2D

# Configurações
var acceleration = 400.0
var max_speed = 300.0
var friction = 500.0

var velocity_x = 0.0

func _physics_process(delta):
	var input = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")

	if input > 0:
		$AnimatedSprite2D.flip_h = false
	elif input < 0:
		$AnimatedSprite2D.flip_h = true

	# Aceleração
	if input != 0:
		velocity_x += input * acceleration * delta
		velocity_x = clamp(velocity_x, -max_speed, max_speed)
		
	else:
		# Desaceleração gradual (atrito)
		if abs(velocity_x) > 0:
			var sign_dir = sign(velocity_x)
			velocity_x -= sign_dir * friction * delta
			if sign(velocity_x) != sign_dir:
				velocity_x = 0.0

	# Aplica o movimento
	velocity.x = velocity_x
	move_and_slide()
