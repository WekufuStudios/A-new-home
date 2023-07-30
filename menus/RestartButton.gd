extends Button


func _ready() -> void:
	pressed.connect(func():
		disabled = true
		get_tree().reload_current_scene()
	)
