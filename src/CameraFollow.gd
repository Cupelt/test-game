extends Camera2D

var to: Vector2;
var current: Vector2;

const BLEND_SPEED = 150;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	to = (get_parent() as CharacterBody2D).position;
	current = to;
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	to = (get_parent() as CharacterBody2D).position;
	current = current.lerp(to, pow(0.5, delta * BLEND_SPEED))
	
	offset = current - to;
	pass
