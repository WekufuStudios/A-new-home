class_name Arrow extends Node2D

const SURFACE_DISTANCE_TO_ZOOM: int = 150

var previous_distance_to_surface: float = 0

var FINAL_PLANET_COLOR: Color = Color.GREEN
var COLORS: PackedColorArray = PackedColorArray([Color("00aade"), Color("c36100"), Color("e0df00")])

var target: Planet = null:
	set(new_target):
		target = new_target
		if target is PlanetFinal:
			$ArrowSprite.modulate = FINAL_PLANET_COLOR
		else:
			$ArrowSprite.modulate = COLORS[target.type]
		set_process(true)

@onready var player: PlayerShip = get_node("../..")


func _ready() -> void:
	set_process(false)


func _process(_delta: float) -> void:
	var vector_to_target: Vector2 = (target.position - player.position)
	rotation = - player.rotation + vector_to_target.angle()

	var distance_to_surface: float = vector_to_target.length() - target.planet_radius
	if distance_to_surface < 200:
		#print(target.planet_radius)
		# print(distance_to_surface)
		if distance_to_surface > SURFACE_DISTANCE_TO_ZOOM and previous_distance_to_surface < SURFACE_DISTANCE_TO_ZOOM:
			player.camera.zoom_out()
		elif distance_to_surface < SURFACE_DISTANCE_TO_ZOOM and previous_distance_to_surface > SURFACE_DISTANCE_TO_ZOOM:
			player.camera.zoom_in()
	previous_distance_to_surface = distance_to_surface
