extends StaticBody2D

var is_triggered = false
var velocity = Vector2.ZERO
var gravity = 1000
var fall_speed = 200

func has_collided_with(collision: KinematicCollision2D, collider: CharacterBody2D):
	if !is_triggered and collider.is_in_group("player"):
		is_triggered = true
		velocity = Vector2.ZERO

func _physics_process(delta):
	if is_triggered:
		velocity.y += gravity * delta

		position += velocity * delta

		if velocity.y > fall_speed:
			velocity.y = fall_speed
