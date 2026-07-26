extends Node2D
class_name WaveManager

var wave: int = 1
var left_time: float = 0

var is_wave_running = false
@onready var spawner = $DeafultSpawner

static var instance: WaveManager

func _ready() -> void:
	instance = self
	start_wave() # Dev only

func _process(delta: float) -> void:
	if not is_wave_running:
		return
		
	left_time -= delta
	if left_time <= 0:
		stop_wave()

func start_wave():
	is_wave_running = true
	left_time = 300
	pass

func stop_wave():
	is_wave_running = false
	pass
