extends Area2D

var life := 1
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	Globals.life += life
	print(Globals.life)

func _on_animation_animation_finished() -> void:
	queue_free()
