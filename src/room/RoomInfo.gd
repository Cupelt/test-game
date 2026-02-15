extends Node2D
class_name RoomInfo

var room_position: Vector2i = Vector2i.MAX

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Area2D.body_entered.connect(_enter_area)
	pass # Replace with function body.

func _enter_area(body: Node2D):
	if (body is not Player):
		return
		
	MapManager.Instance.on_change_room.emit(body.map_pos, room_position)
	body.map_pos = room_position
	
	_left_fog(null, room_position)
	
func _left_fog(ignored, pos: Vector2):
	var viewport_size = get_viewport().get_visible_rect().size
	var screen_pos = get_viewport().get_canvas_transform() * pos
	
	$Fog.material.set_shader_parameter("player_pos", screen_pos)
	
	var camera_tween = create_tween()
	camera_tween.tween_property($Fog.material, 
			"shader_parameter/view_radius", 
			1000, 1)\
		.set_trans(Tween.TRANS_CUBIC)\
		.set_ease(Tween.EASE_OUT)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
