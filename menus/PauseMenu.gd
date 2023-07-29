extends Control


func _ready() -> void:
	hide()

	$VBoxContainer/ResumeButton.pressed.connect(func():
		hide()
		get_tree().paused = false
	)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_pause"):
		if visible:
			hide()
			get_tree().paused = false
		else:
			show()
			get_tree().paused = true
