class_name MissileCanon extends Node2D

const PROJECTILE_SCENE: PackedScene = preload("res://ships/Missile.tscn")
# const SOUNDS: Array[AudioStream] = [preload("res://assets/sounds/Laser Gun 1.mp3"), preload("res://assets/sounds/Laser Gun 2.mp3"), preload("res://assets/sounds/Laser Gun 3.mp3")]


func shoot(dir: Vector2, speed: int) -> void:
	for marker2d in get_children():
		var projectile: Missile = PROJECTILE_SCENE.instantiate()
		projectile.position = marker2d.global_position
		get_tree().current_scene.add_child(projectile)
		projectile.shoot(get_parent(), dir, speed)
		projectile.target = Globals.player
#	var audio: AudioStreamPlayer2D = AudioStreamPlayer2D.new()
#	audio.position = global_position
#	audio.stream = SOUNDS[randi() % SOUNDS.size()]
#	audio.volume_db = -12
#	audio.finished.connect(audio.queue_free)
#	get_tree().current_scene.add_child(audio)
#	audio.play()
