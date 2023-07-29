extends CanvasLayer

var condition_tween: Tween = null
var fuel_tween: Tween = null

@onready var player: PlayerShip = get_parent()
@onready var condition_bar: TextureProgressBar = $MarginContainer/VBoxContainer/HBoxContainer/ConditionBar
@onready var fuel_bar: TextureProgressBar = $MarginContainer/VBoxContainer/HBoxContainer2/FuelBar


func _ready() -> void:
	await player.ready

	condition_bar.value = 100
	player.life_component.hp_changed.connect(func(new_hp: int):
		# I think this is not necessary
#		if condition_tween == null or condition_tween.is_running():
#			condition_tween.kill()
		condition_tween = create_tween()
		condition_tween.tween_property(condition_bar, "value", new_hp, 0.4).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	)

	fuel_bar.value = 100
	player.fuel_changed.connect(func(new_fuel: float):
		# I think this is not necessary
#		if fuel_tween != null and fuel_tween.is_running():
#			fuel_tween.kill()
		fuel_tween = create_tween()
		fuel_tween.tween_property(fuel_bar, "value", round(new_fuel), 0.4).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	)
