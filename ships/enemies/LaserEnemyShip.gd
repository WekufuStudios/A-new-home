extends Ship

var is_turning: bool = false

@onready var player: PlayerShip = Globals.player
@onready var laser: Laser = $Laser


func _ready() -> void:
	super()
	speed = 5000
	rot_speed = 1000

	rotation = randf_range(0, 2*PI)


func _physics_process(delta: float) -> void:
	super(delta)

	var vector_to_player: Vector2 = player.position - position

	var angle_to_player: float = Vector2.UP.rotated(rotation).angle_to(vector_to_player)
	#print(angle_to_player)
	if angle_to_player < -0.1 and not is_turning:
		_start_turning_left()
		is_turning = true
	elif angle_to_player > 0.1 and not is_turning:
		_start_turning_right()
		is_turning = true
	elif angle_to_player > -0.1 and angle_to_player < 0.1:
		if is_turning:
			if turn_dir == 1:
				_stop_turning_right()
				is_turning = false
			elif turn_dir == -1:
				_stop_turning_left()
				is_turning = false

	if mov_direction != Vector2.UP:
		if abs(angle_to_player) < 0.2 and angular_velocity < 5:
			if vector_to_player.length() > laser.get_range():
				_start_going_forward()
	else:
		if vector_to_player.length() < laser.get_range() or abs(angle_to_player) > 1.5:
			_stop_going_forward()

	if vector_to_player.length() < laser.get_range() and not laser.is_on() and abs(angle_to_player) < 0.2 and angular_velocity < 5:
		laser.turn_on()
	elif (vector_to_player.length() > laser.get_range() or abs(angle_to_player) > 0.2) and laser.is_on():
		laser.turn_off()


func _on_destroy() -> void:
	super()
	queue_free()
