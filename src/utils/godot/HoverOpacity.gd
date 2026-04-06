extends CanvasItem
class_name HoverOpacity

var is_showed = false

@export_range(0, 1, 0) var MAX_OPACITY: float = 1.0
@export_range(0, 1, 0) var MIN_OPACITY: float = 0.4

@export var BLEND_SPEED: float = 150

func _ready() -> void:
	modulate.a = MIN_OPACITY

func _process(delta: float) -> void:
	
	var to
	if is_showed:
		to = MAX_OPACITY
	else:
		to = MIN_OPACITY
	
	modulate.a = lerpf(modulate.a, to, pow(0.5, delta * BLEND_SPEED))
