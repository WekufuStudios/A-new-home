class_name Missile extends Projectile

var target: Node2D = null


func _ready() -> void:
	dam = 10
	life_time = 7
	explosion_scene = load("res://ships/MissileExplosion.tscn")
	explosion_scale = 0.5
	super()

	$SmallThruster.add()


func _physics_process(delta: float) -> void:
	if target:
		var new_angle: float = lerp_angle(dir.angle(), (target.position - position).angle(), 0.02)
		dir = Vector2.RIGHT.rotated(new_angle)
		rotation = dir.angle()

	super(delta)
