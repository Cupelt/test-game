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
	
	if !MapManager.Instance.visitedPos.has(room_position):
		_left_fog(body.global_position)
		MapManager.Instance.visitedPos.append(room_position)
	
func _left_fog(pos: Vector2):
	$BackBufferCopy/FogCutter.global_position = pos
	$BackBufferCopy/FogCutter.visible = true
	
	var cutter_tween = create_tween()
	cutter_tween.tween_property($BackBufferCopy/FogCutter, 
			"scale", Vector2(15, 15), 2)\
		.set_trans(Tween.TRANS_CUBIC)\
		.set_ease(Tween.EASE_OUT)
	
	await cutter_tween.finished
	$BackBufferCopy.queue_free()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
