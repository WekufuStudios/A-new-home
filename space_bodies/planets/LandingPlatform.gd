class_name LandingPlatform extends Area2D

var player: PlayerShip = null

@onready var land_timer: Timer = $LandTimer


func _ready() -> void:
	set_process(false)

	body_entered.connect(func(body: Node2D):
		assert(body == Globals.player)
		player = body
		set_process(true)
	)

	body_exited.connect(func(body: Node2D):
		assert(body == Globals.player)
		set_process(false)
	)

	land_timer.timeout.connect(func():
		$CollisionShape2D.queue_free()
		set_process(false)
		player.disabled = true
		get_parent().show_ui()
	)


func _process(_delta: float) -> void:
	if not player.disabled and land_timer.is_stopped() and player.linear_velocity.length() < player.MAX_LINEAR_VELOCITY_TO_LAND and player.angular_velocity < player.MAX_ANGULAR_VELOCITY_TO_LAND and abs(player.global_rotation - global_rotation) < 0.4:
		land_timer.start()
	elif (player.mov_direction != Vector2.ZERO or player.turn_dir != 0 or abs(player.global_rotation - global_rotation) > 0.4) and not land_timer.is_stopped():
		land_timer.stop()
