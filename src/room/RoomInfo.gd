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
	
	print(body.map_pos)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
