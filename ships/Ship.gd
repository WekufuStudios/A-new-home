@icon("res://assets/art/ships/ship-1.png")
class_name Ship extends RigidBody2D

const SHIP_EXPLOSION_SCENE: PackedScene = preload("res://ships/ShipExplosion.tscn")

@export var speed: int = 20000
@export var rot_speed: int = 15000


var mov_direction: Vector2 = Vector2.ZERO
var turn_dir: int = 0

var disabled: bool = false: set = set_disabled

var enabled_thusters: Array[String] = []
@onready var thrusters: Dictionary = {
	"up": $Thrusters/Up.get_children(),
	"down": $Thrusters/Down.get_children(),
	"left_up": $Thrusters/LeftUp.get_children(),
	"left_down": $Thrusters/LeftDown.get_children(),
	"right_up": $Thrusters/RightUp.get_children(),
	"right_down": $Thrusters/RightDown.get_children(),
}
@onready var life_component: LifeComponent = $LifeComponent


func _ready() -> void:
	contact_monitor = true
	max_contacts_reported = 1
	body_entered.connect(func(body: PhysicsBody2D):
		if body is RigidBody2D:
			var velocity_lenght_diff: float = abs((linear_velocity - body.linear_velocity).length())
			# print(velocity_lenght_diff)
			if velocity_lenght_diff > 30:
				life_component.take_damage(round(velocity_lenght_diff/5.0))
		elif body is StaticBody2D:
			if linear_velocity.length() > 20:
				life_component.take_damage(round(linear_velocity.length()/4.0))
		else:
			push_warning("Implement something here")
	)

	life_component.died.connect(_on_destroy)


func _physics_process(_delta: float) -> void:
#	for body in get_colliding_bodies():
#		print(body.name)
	apply_central_force(mov_direction.rotated(rotation) * speed)
	apply_torque(turn_dir * rot_speed)



func _on_destroy() -> void:
	var explosion: Sprite2D = SHIP_EXPLOSION_SCENE.instantiate()
	explosion.position = position
	explosion.rotation = randf_range(0, 2*PI)
	get_tree().current_scene.add_child(explosion)


func _enable_thrusters(at: String) -> void:
	for thruster in thrusters[at]:
		thruster.add()


func _disable_thrusters(at: String) -> void:
	for thruster in thrusters[at]:
		thruster.remove()


func _start_going_forward() -> void:
	mov_direction += Vector2.UP
	_enable_thrusters("down")


func _stop_going_forward() -> void:
	mov_direction -= Vector2.UP
	_disable_thrusters("down")


func _start_going_backwards() -> void:
	mov_direction += Vector2.DOWN
	_enable_thrusters("up")


func _stop_going_backwards() -> void:
	mov_direction -= Vector2.DOWN
	_disable_thrusters("up")


func _start_going_right() -> void:
	mov_direction += Vector2.RIGHT
	_enable_thrusters("left_up")
	_enable_thrusters("left_down")


func _stop_going_right() -> void:
	mov_direction -= Vector2.RIGHT
	_disable_thrusters("left_up")
	_disable_thrusters("left_down")


func _start_going_left() -> void:
	mov_direction += Vector2.LEFT
	_enable_thrusters("right_up")
	_enable_thrusters("right_down")


func _stop_going_left() -> void:
	mov_direction -= Vector2.LEFT
	_disable_thrusters("right_up")
	_disable_thrusters("right_down")


func _start_turning_left() -> void:
	turn_dir -= 1
	_enable_thrusters("right_up")
	_enable_thrusters("left_down")


func _stop_turning_left() -> void:
	turn_dir += 1
	_disable_thrusters("right_up")
	_disable_thrusters("left_down")


func _start_turning_right() -> void:
	turn_dir += 1
	_enable_thrusters("left_up")
	_enable_thrusters("right_down")


func _stop_turning_right() -> void:
	turn_dir -= 1
	_disable_thrusters("left_up")
	_disable_thrusters("right_down")


func set_disabled(new_value: bool) -> void:
	if new_value != disabled:
		disabled = new_value
