extends CharacterBody2D

enum PlayerState {
	idle,
	walk,
	jump,
	hurt
}

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
const KNOCKBACK_FORCE = Vector2(100, -100)

const SPEED = 150.0
const JUMP_VELOCITY = -400.0
var last_direction = 1
var is_invulnerable = false
var player_life = 3
var hurt_duration = 0.2 
var hurt_timer = 0.0

@export var max_jump_count = 2

var jump_count = 0

var status: PlayerState

func _ready() -> void:
	go_to_idle_state()

func _physics_process(delta: float) -> void:
	
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	# cooldown
	if is_invulnerable:
		hurt_timer -= delta
		if hurt_timer <= 0:
			is_invulnerable = false
			
			if is_on_floor():
				go_to_idle_state()
			else:
				go_to_jump_state()
				
	if $ray_right.is_colliding() and not is_invulnerable:
		var collider = $ray_right.get_collider()
		if collider and collider.is_in_group("enemies"):
			player_life -= 1
			go_to_hurt_state()
			return
		
	match status:
		PlayerState.idle:
			idle_state()
		PlayerState.walk:
			walk_state()
		PlayerState.jump:
			jump_state()
		PlayerState.hurt:
			hurt_state()
			
	for platforms in get_slide_collision_count():
		var collision = get_slide_collision(platforms)
		if collision.get_collider().has_method("has_collided_with"):
			collision.get_collider().has_collided_with(collision, self)
	
	move_and_slide()

func go_to_idle_state():
	status = PlayerState.idle
	anim.play("idle")

func go_to_walk_state():
	status = PlayerState.walk
	anim.play("walking")

func go_to_jump_state():
	status = PlayerState.jump
	anim.play("jump")
	velocity.y = JUMP_VELOCITY

func go_to_hurt_state():
	if is_invulnerable:
		return 
	if player_life == 0:
		get_tree().reload_current_scene()
	
	status = PlayerState.hurt
	anim.play("hurt")
	is_invulnerable = true
	hurt_timer = hurt_duration
	
	var knockback_direction = -last_direction
	velocity.x = knockback_direction * KNOCKBACK_FORCE.x
	velocity.y = KNOCKBACK_FORCE.y

func idle_state():
	move()
	
	if velocity.x != 0:
		go_to_walk_state()
		return
	
	if Input.is_action_just_pressed("jump"):
		go_to_jump_state()
		return

func walk_state():
	move()
	if velocity.x == 0:
		go_to_idle_state()
		return
		
	if Input.is_action_just_pressed("jump"):
		go_to_jump_state()
		return

func jump_state():
	move()
	if is_on_floor():
		if velocity.x == 0:
			go_to_idle_state()
		else:
			go_to_walk_state()
		return

func hurt_state():
	pass

func move():
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
		last_direction = direction
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if velocity.x > 0:
		anim.flip_h = false
	elif velocity.x < 0:
		anim.flip_h = true


func _on_death_zone_body_entered(body: Node2D) -> void:
	get_tree().reload_current_scene()
	
