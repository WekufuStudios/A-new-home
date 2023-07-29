class_name PlayerShip extends Ship

const MAX_LINEAR_VELOCITY_TO_LAND: int = 1
const MAX_ANGULAR_VELOCITY_TO_LAND: float = 1.5


signal fuel_changed(new_fuel: float)
var fuel: float = 100:
	set(new_fuel):
		fuel = clamp(new_fuel, 0, 100)
		if fuel == 0:
			mov_direction = Vector2.ZERO
			turn_dir = 0
			for thruster_location_name in thrusters:
				_disable_thrusters(thruster_location_name)
		fuel_changed.emit(fuel)

var contacts_with_planet: int = 0

@onready var canon: Canon = $Canon
@onready var land_timer: Timer = $LandTimer
@onready var attack_timer: Timer = $AttackTimer


func _ready() -> void:
	super()

	Globals.player = self

	land_timer.timeout.connect(func():
		disabled = true
		print("Landed!")
	)

	attack_timer.timeout.connect(func():
		canon.shoot(Vector2.UP.rotated(rotation), 100)
	)

	body_entered.connect(func(body: PhysicsBody2D):
		if body is Planet:
			contacts_with_planet += 1
	)
	body_exited.connect(func(body: PhysicsBody2D):
		if body is Planet:
			contacts_with_planet -= 1
	)

	for thruster_location in thrusters.values():
		for thruster in thruster_location:
			thruster.fuel_consumed.connect(func(amount: float):
				fuel -= amount
			)


func _exit_tree() -> void:
	Globals.player = null


func _unhandled_input(event: InputEvent) -> void:
	if fuel > 0 and not disabled:
		if event.is_action_pressed("ui_move_forward"):
			_start_going_forward()
		elif event.is_action_released("ui_move_forward"):
			_stop_going_forward()

		if event.is_action_pressed("ui_move_backwards"):
			_start_going_backwards()
		elif event.is_action_released("ui_move_backwards"):
			_stop_going_backwards()

		if event.is_action_pressed("ui_move_right"):
			_start_going_right()
		elif event.is_action_released("ui_move_right"):
			_stop_going_right()

		if event.is_action_pressed("ui_move_left"):
			_start_going_left()
		elif event.is_action_released("ui_move_left"):
			_stop_going_left()

		if event.is_action_pressed("ui_turn_left"):
			_start_turning_left()
		elif event.is_action_released("ui_turn_left"):
			_stop_turning_left()

		if event.is_action_pressed("ui_turn_right"):
			_start_turning_right()
		elif event.is_action_released("ui_turn_right"):
			_stop_turning_right()

	if not disabled and event.is_action_pressed("ui_attack"):
		attack_timer.start()
	elif event.is_action_released("ui_attack"):
		attack_timer.stop()


func _physics_process(delta: float) -> void:
	super(delta)

	if contacts_with_planet > 0 and not disabled and land_timer.is_stopped() and linear_velocity.length() < MAX_LINEAR_VELOCITY_TO_LAND and angular_velocity < MAX_ANGULAR_VELOCITY_TO_LAND:
		land_timer.start()
	elif contacts_with_planet == 0 and not land_timer.is_stopped():
		land_timer.stop()


func set_disabled(new_value: bool) -> void:
	if new_value != disabled and disabled == true:
		attack_timer.stop()
	super(new_value)
