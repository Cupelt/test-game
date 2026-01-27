extends TextureRect

@export_range(0, 1, 0.1) var MAX_OPACITY: float = 1.0
@export_range(0, 1, 0.1) var MIN_OPACITY: float = 0.4

@export var BLEND_SPEED: float = 150
var to: float;

func _ready() -> void:
	modulate.a = MIN_OPACITY
	to = MIN_OPACITY
	
	mouse_entered.connect(func (): to = MAX_OPACITY)
	mouse_exited.connect(func (): to = MIN_OPACITY)

func _process(delta: float) -> void:
	modulate.a = lerpf(modulate.a, to, pow(0.5, delta * BLEND_SPEED))
