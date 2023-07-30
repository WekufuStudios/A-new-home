class_name Planet extends StaticBody2D

var landed_on_it: bool = false

enum Type {
	LANDABLE,
	GAS_GIANT,
	SUN,
}
@export var type: Type = Type.LANDABLE

@onready var sprite: AnimatedSprite2D = $Planet
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

@onready var ui: PanelContainer = $UI/PanelContainer


func _ready() -> void:
	ui.hide()
	$UI/PanelContainer/MarginContainer/HBoxContainer/PanelContainer/ShieldButton.pressed.connect(func():
		landed_on_it = true
		ui.hide()
		Globals.player.life_component.hp = 100
		Globals.player.disabled = false
	)
	$UI/PanelContainer/MarginContainer/HBoxContainer/PanelContainer2/FuelButton.pressed.connect(func():
		landed_on_it = true
		ui.hide()
		Globals.player.fuel = 100
		Globals.player.disabled = false
	)

	var planet_radius: float = sprite.sprite_frames.get_frame_texture("default", 0).get_width() / 2.0

	var planet_col_shape: CircleShape2D = CircleShape2D.new()
	planet_col_shape.radius = planet_radius if type == Type.LANDABLE else 16
	collision_shape.shape = planet_col_shape

	var gravity_range: float = planet_radius * 4

	var gravity_area: Area2D = Area2D.new()
	gravity_area.name = "GravityArea"
	gravity_area.set_collision_layer_value(1, false)
	gravity_area.set_collision_mask_value(2, true)
	gravity_area.set_collision_mask_value(3, true)
	gravity_area.gravity_space_override = Area2D.SPACE_OVERRIDE_COMBINE
	gravity_area.gravity_point = true
	gravity_area.gravity_point_unit_distance = planet_radius
	gravity_area.gravity_point_center = Vector2.ZERO
	gravity_area.gravity = planet_radius / 5.0
	gravity_area.linear_damp_space_override = Area2D.SPACE_OVERRIDE_COMBINE
	gravity_area.linear_damp = 0.2
	gravity_area.angular_damp_space_override = Area2D.SPACE_OVERRIDE_COMBINE
	gravity_area.angular_damp = 0.2
	add_child(gravity_area)

	var col: CollisionShape2D = CollisionShape2D.new()
	var shape: CircleShape2D = CircleShape2D.new()
	shape.radius = gravity_range
	col.shape = shape
	gravity_area.add_child(col)


func show_ui() -> void:
	ui.show()
