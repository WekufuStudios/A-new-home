class_name Projectile extends Area2D


var dir: Vector2
var speed: int
var shooter: Node2D

var dam: int = 2
var life_time: float = 2


func _ready() -> void:
	body_entered.connect(func(body: Node2D):
		if body != shooter:
			if body is Ship:
				body.life_component.take_damage(dam)
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
