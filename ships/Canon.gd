class_name Canon extends Node2D

const PROJECTILE_SCENE: PackedScene = preload("res://ships/Projectile.tscn")


func shoot(dir: Vector2, speed: int) -> void:
	for marker2d in get_children():
		var projectile: Projectile = PROJECTILE_SCENE.instantiate()
		projectile.position = marker2d.global_position
		get_tree().current_scene.add_child(projectile)
		projectile.shoot(dir, speed)
