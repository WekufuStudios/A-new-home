class_name Laser extends RayCast2D

var width_tween: Tween = null

var collider: Object = null

@onready var texture_line: Line2D = $TextureLine
@onready var damage_timer: Timer = $DamageTimer
@onready var collide_particles: GPUParticles2D = $CollideParticles


func _ready() -> void:
	texture_line.width = 0
	enabled = false
	collide_particles.emitting = false
	damage_timer.timeout.connect(func():
		if collider is Ship:
			collider.life_component.take_damage(2)
	)


func _process(_delta: float) -> void:
	collider = get_collider()
	if collider:
		var length: float = (get_collision_point() - global_position).length()
		texture_line.points[1].x = length
		collide_particles.position.x = length
		if damage_timer.is_stopped():
			damage_timer.start()
			collide_particles.emitting = true
	else:
		if not damage_timer.is_stopped():
			damage_timer.stop()
			collide_particles.emitting = false
		texture_line.points[1].x = target_position.x


func turn_on() -> void:
	set_process(true)
	enabled = true
	width_tween = create_tween()
	width_tween.tween_property(texture_line, "width", 4, 0.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)


func turn_off() -> void:
	set_process(false)
	enabled = false
	collide_particles.emitting = false
	damage_timer.stop()
	width_tween = create_tween()
	width_tween.tween_property(texture_line, "width", 0, 0.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)


func get_range() -> float:
	return target_position.x


func is_on() -> bool:
	return enabled
