extends Button


func _ready() -> void:
	if OS.has_feature("web"):
		queue_free()
	pressed.connect(func(): get_tree().quit())
