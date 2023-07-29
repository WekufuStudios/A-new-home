class_name LifeComponent extends Node

var invincible: bool = false

## Value between 0 and 100 where 0 is impossible to block and 100 is 100% blocking probability
var block_probability: int = 0

@export var hp: int:
	set(new_hp):
		hp = clamp(new_hp, 0, max_hp)
		hp_changed.emit(hp)
		if hp == 0:
			died.emit()
		#print(hp)
@export var max_hp: int

signal hp_changed(new_hp: int)
signal damage_taken(dam: int, dir: Vector2, force: int)
signal died()


func _ready() -> void:
	self.hp = max_hp


func take_damage(dam: int, dir: Vector2 = Vector2.ZERO, force: int = 0) -> void:
	if invincible:
		return

	if block_probability > 0:
		if randi() % 100 < block_probability:
			print_debug("Blocked")
			return

	self.hp -= dam

	damage_taken.emit(dam, dir, force)
