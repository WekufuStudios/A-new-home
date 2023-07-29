extends GPUParticles2D


var force: int = 10000
var consumption_per_second: float = 0.5
var time: float = 0.0
signal fuel_consumed(amount: float)

var directions_enabling_thruster: int = 0


func _init() -> void:
	emitting = false


func _ready() -> void:
	set_process(false)


func _process(delta: float) -> void:
	time += delta
	if time >= 1:
		time = 0
		fuel_consumed.emit(consumption_per_second)


func add() -> void:
	directions_enabling_thruster += 1
	if not emitting:
		emitting = true
		set_process(true)


func remove() -> void:
	directions_enabling_thruster -= 1
	if directions_enabling_thruster < 0:
		directions_enabling_thruster = 0
	if directions_enabling_thruster == 0:
		emitting = false
		set_process(false)
