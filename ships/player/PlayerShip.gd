class_name PlayerShip extends Ship

const MAX_LINEAR_VELOCITY_TO_LAND: int = 1
const MAX_ANGULAR_VELOCITY_TO_LAND: float = 1.5

const ARROW_SCENE: PackedScene = preload("res://ships/player/Arrow.tscn")

signal fuel_changed(new_fuel: float)
var fuel: float = 100:
	set(new_fuel):
		fuel = clamp(new_fuel, 0, 100)
		if fuel == 0:
			out_of_fuel_timer.start()
			mov_direction = Vector2.ZERO
			turn_dir = 0
			for thruster_location_name in thrusters:
				_disable_thrusters(thruster_location_name)
		fuel_changed.emit(fuel)

@onready var camera: Camera2D = $Camera
@onready var canon: Canon = $Canon
@onready var attack_timer: Timer = $AttackTimer
@onready var out_of_fuel_timer: Timer = $OutOfFuelTimer
@onready var ui: CanvasLayer = $UI
@onready var arrows: Node2D = $Arrows
@onready var planet_detector: Area2D = $PlanetDetector
@onready var enemy_detector: Area2D = $EnemyDetector


func _ready() -> void:
	super()

	Globals.player = self

	attack_timer.timeout.connect(func():
		canon.shoot(Vector2.UP.rotated(rotation), 150)
	)

#	body_entered.connect(func(body: PhysicsBody2D):
#		if body is Planet and not body.landed_on_it:
#			planet = body
#			contacts_with_planet += 1
#	)
#	body_exited.connect(func(body: PhysicsBody2D):
#		if body is Planet:
#			planet = null
#			contacts_with_planet -= 1
#	)

	for thruster_location in thrusters.values():
		for thruster in thruster_location:
			thruster.fuel_consumed.connect(func(amount: float):
				fuel -= amount
			)

	var final_planet_arrow: Arrow = ARROW_SCENE.instantiate()
	arrows.add_child(final_planet_arrow)
	final_planet_arrow.target = Globals.planet_final

	planet_detector.body_entered.connect(func(body: Node2D):
		if body is Planet and not body is PlanetFinal:
			var arrow: Arrow = ARROW_SCENE.instantiate()
			arrows.add_child(arrow)
			arrow.target = body
			if body.type in [Planet.Type.GAS_GIANT, Planet.Type.SUN]:
				ui.add_danger()
	)
	planet_detector.body_exited.connect(func(body: Node2D):
		if body is Planet and not body is PlanetFinal:
			for arrow in arrows.get_children():
				if arrow.target == body:
					arrow.queue_free()
					if body.type in [Planet.Type.GAS_GIANT, Planet.Type.SUN]:
						ui.remove_danger()
	)

	enemy_detector.body_entered.connect(func(_body: Node2D):
		camera.zoom_in()
	)
	enemy_detector.body_exited.connect(func(_body: Node2D):
		camera.zoom_out()
	)

	out_of_fuel_timer.timeout.connect(func():
		disabled = true
		$UI/PauseMenu.queue_free()
		$UI/GameOverMenu.show()
		$Arrows.hide()
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

	#print(OS.get_static_memory_usage() / 1000.0 / 1000.0)

#	if contacts_with_planet > 0 and not disabled and land_timer.is_stopped() and linear_velocity.length() < MAX_LINEAR_VELOCITY_TO_LAND and angular_velocity < MAX_ANGULAR_VELOCITY_TO_LAND:
#		land_timer.start()
#	elif (contacts_with_planet == 0 or mov_direction != Vector2.ZERO or turn_dir != 0) and not land_timer.is_stopped():
#		land_timer.stop()


func set_disabled(new_value: bool) -> void:
	if new_value != disabled and disabled == true:
		attack_timer.stop()
	super(new_value)


func _on_destroy() -> void:
	super()
	if fuel == 0 and out_of_fuel_timer.is_stopped():
		return
	disabled = true
	$Sprite2D.hide()
	$CollisionPolygon2D.queue_free()
	$UI/PauseMenu.queue_free()
	$UI/GameOverMenu.show()
	$Arrows.hide()
