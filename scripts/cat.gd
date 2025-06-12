extends CharacterBody2D

var direction
@onready var animation: AnimatedSprite2D = $animation
const SPEED = 160.0
const JUMP_VELOCITY = -350.0
@export var player_life := 3 
var knockback_vector := Vector2.ZERO

var jump_max = 2
var jump_count = 0

func _physics_process(delta: float) -> void:
	
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if is_on_floor() and jump_count!=0:
		jump_count = 0
	
	if jump_count < jump_max:
		if Input.is_action_just_pressed("jump"):
			velocity.y = JUMP_VELOCITY
			jump_count += 1
	
	direction = Input.get_axis("left", "right")
	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	if velocity.x > 0:
		animation.flip_h = false
	elif velocity.x < 0:
		animation.flip_h = true
	
	if knockback_vector != Vector2.ZERO:
		velocity = knockback_vector
	
	_set_state()
	move_and_slide()
	
func _set_state():
	var state = "idle"
	
	if !is_on_floor():
		state = "jump"
		
	elif direction != 0:
		state = "running"
	
	if animation.name != state:
		animation.play(state)
		
	for platforms in get_slide_collision_count():
		var collision = get_slide_collision(platforms)
		if collision.get_collider().has_method("has_collided_with"):
			collision.get_collider().has_collided_with(collision, self)
	
func _on_hurtbox_body_entered(body: Node2D) -> void:
	if player_life < 0:
		queue_free()
	
func take_damage(knockback_force := Vector2.ZERO, duration := 0.25):
	player_life -= 1
	
	if knockback_force != Vector2.ZERO:
		knockback_vector = knockback_force
		var knockback_tween := get_tree().create_tween()
		knockback_tween.tween_property(self, "knockback_vector", Vector2.ZERO, duration)
