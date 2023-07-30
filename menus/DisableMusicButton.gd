extends Button


func _ready() -> void:
	toggle_mode = true

	toggled.connect(func(is_toggled: bool):
		AudioServer.set_bus_mute(0, is_toggled)
	)
