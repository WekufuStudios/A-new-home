class_name Arrow extends Node2D

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


func _process(delta: float) -> void:
	rotation = - player.rotation + (target.position - player.position).angle()
