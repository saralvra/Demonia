extends CharacterBody2D

func _physics_process(delta: float) -> void:
	pass
	
func _on_level_end_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		$animation.play("achieve")
