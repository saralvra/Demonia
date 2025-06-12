extends Control

@onready var coins_counter: Label = $MarginContainer/HBoxContainer/TextureRect/coins_counter
@onready var life_counter: Label = $MarginContainer2/HBoxContainer/TextureRect/life_counter


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	coins_counter.text = str("%03d" % Globals.coins)
	#life_counter.text = str("%01" % Globals.player_life)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	coins_counter.text = str("%03d" % Globals.coins)
	#life_counter.text = str("%01" % Globals.player_life)
