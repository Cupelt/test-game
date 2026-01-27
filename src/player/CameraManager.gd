extends Camera2D

var to: Vector2;
@export var BLEND_SPEED = 150;

#func set_camera_position(pos: Vector2) -> void:
	#to = pos

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# zoom = Vector2(0.5, 0.5);
	# zoom = Vector2(2.15, 2.15);
	to = global_position;
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	to = MapManager.Instance.room_pos_to_global_pos(MapManager.Instance.currentPlayerPos)
	global_position = global_position.lerp(to, pow(0.5, delta * BLEND_SPEED))
	pass
