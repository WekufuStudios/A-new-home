extends Button


func _ready() -> void:
	pressed.connect(func():
		disabled = true
		get_tree().change_scene_to_file("res://Game.tscn")
	)
