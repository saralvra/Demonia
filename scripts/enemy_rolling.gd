extends CharacterBody2D

@onready var wall_detector := $WallDetect as RayCast2D
@onready var wall_detector2 := $WallDetect2 as RayCast2D
@onready var fall_detector := $FallDetect as RayCast2D

var direction := -1

@export var SPEED = 100.0

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if wall_detector.is_colliding():
		direction *= -1
		
	if wall_detector2.is_colliding():
		direction *= -1
	
	if !fall_detector.is_colliding():
		direction *= -1

	if direction == 1:
		$anim.flip_h = true
	else:
		$anim.flip_h = false


	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		queue_free()
