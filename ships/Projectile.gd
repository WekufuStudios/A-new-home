class_name Projectile extends Area2D


var dir: Vector2
var speed: int
var shooter: Node2D

var explosion_scene: PackedScene = load("res://ships/SmallExplosion.tscn")
var explosion_scale: float = 0.3
var dam: int = 2
var life_time: float = 2


func _ready() -> void:
	body_entered.connect(func(body: Node2D):
		if body != shooter:
			if body is Ship:
				body.life_component.take_damage(dam)

			var audio: AudioStreamPlayer2D = AudioStreamPlayer2D.new()
			audio.position = global_position
			audio.stream = load("res://assets/sounds/hit.mp3")
			audio.volume_db = -20
			audio.finished.connect(audio.queue_free)
			get_tree().current_scene.add_child(audio)
			audio.play()

			var explosion: Sprite2D = explosion_scene.instantiate()
			explosion.position = position
			explosion.scale = Vector2(explosion_scale, explosion_scale)
			get_tree().current_scene.add_child(explosion)

			queue_free()
	)
	area_entered.connect(func(area: Area2D):
		if area is Projectile:
			queue_free()
	)

	await get_tree().create_timer(life_time).timeout

	queue_free()


@warning_ignore("shadowed_variable")
func shoot(shooter: Node2D, dir: Vector2, speed: int) -> void:
	self.shooter = shooter
	self.dir = dir
	self.speed = speed
	rotation = dir.angle()


func _physics_process(delta: float) -> void:
	position += dir * speed * delta
