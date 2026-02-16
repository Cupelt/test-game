extends Node2D
class_name RoomData

@export var fog: Node2D
@export var road: Dictionary[Vector2i, Node2D]
var room_position: Vector2i = Vector2i.MAX
var adjacent_rooms: Array[Vector2i]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Area2D.body_entered.connect(_enter_area)
	pass # Replace with function body.
	
func init(adjacent_dirs: Array[Vector2i]) -> void:
	for dir in adjacent_dirs:
		#var instance: Node2D = corridor_scene.instantiate()
		#tilemap.add_child(instance)
		#
		#var offset: Vector2 = room_size * dir / 2.0
		#var corridor_offset: Vector2 = dir * corridor_size / 2.0
#
		#instance.global_position = (target_pos as Vector2 + offset + corridor_offset + Vector2(-0.5, -0.5)) * 16
		road[dir].set_process(false)

func _enter_area(body: Node2D):
	if (body is not Player):
		return
	
	Event.on_change_room.emit(body.map_pos, room_position)
	body.map_pos = room_position
	
	if !Event.visitedPos.has(room_position):
		Event.visitedPos.append(room_position)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
