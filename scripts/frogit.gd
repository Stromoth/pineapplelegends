extends Node2D

var direction = 1

@onready var raycastright: RayCast2D = $raycastright
@onready var raycastleft: RayCast2D = $raycastleft
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _process(delta):
	if raycastright.is_colliding():
		direction = -1
		animated_sprite_2d.flip_h = true
	if raycastleft.is_colliding():
		direction = 1
		animated_sprite_2d.flip_h = false
	position.x += direction * 60 * delta
	
