class_name PlanetFinal extends Planet


func _ready() -> void:
	super()

	Globals.planet_final = self


func show_ui() -> void:
	get_tree().change_scene_to_file("res://menus/VictoryScreen.tscn")
