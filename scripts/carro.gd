extends CharacterBody2D

@onready var sensor = $Area2D
var player_inside = false
var player_ref = null
var speed = 200.0

func _ready():
	sensor.body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.name == "protagonista" and not player_inside:
		player_ref = body
		player_inside = true
		player_ref.hide()
		player_ref.set_physics_process(false)
		print("Entrou no carro")

func _physics_process(_delta):
	if player_inside:
		var input = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
		velocity.x = input * speed
		move_and_slide()

		if Input.is_action_just_pressed("ui_accept"): # tecla E
			sair_do_carro()

func sair_do_carro():
	if player_ref:
		player_ref.global_position = global_position + Vector2(50, 0)
		player_ref.show()
		player_ref.set_physics_process(true)
		player_inside = false
		player_ref = null
		print("Saiu do carro")
