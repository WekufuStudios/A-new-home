class_name Projectile extends Area2D


var dir: Vector2
var speed: int


func _ready() -> void:
	body_entered.connect(func(body: Node2D):
		if body is Ship:
			body.life_component.take_damage(2)
		queue_free()
	)

	await get_tree().create_timer(2).timeout

	queue_free()


@warning_ignore("shadowed_variable")
func shoot(dir: Vector2, speed: int) -> void:
	self.dir = dir
	self.speed = speed
	rotation = dir.angle()


func _physics_process(delta: float) -> void:
	position += dir * speed * delta
