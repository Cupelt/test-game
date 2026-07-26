extends RichTextLabel

@export var wave_manager: WaveManager
@onready var origin = text

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var left_time = wave_manager.left_time
	var left_minutes = left_time / 60
	var left_seconds = fmod(left_time, 60)
	
	var left_time_str = "%02d : %02d" % [left_minutes, left_seconds]
	var status = "[color=green]safe"
	
	text = origin % [left_time_str, status]
	pass
