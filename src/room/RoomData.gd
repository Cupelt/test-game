extends Node2D
class_name RoomData

@export var road_colider: Dictionary[Vector2i, TileMapLayer]
@export var fog_scene: PackedScene

var room_position: Vector2i = Vector2i.MAX
var type: AbstractRoom

var fog_instnace: Node2D = null
var is_visited = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Area2D.body_entered.connect(_enter_area)
	pass # Replace with function body.
	
func init(room_position: Vector2i, type: AbstractRoom, adjacent_dirs: Array[Vector2i]) -> void:
	self.room_position = room_position
	self.type = type
	
	for dir in adjacent_dirs:
		# road[dir].set_process(true)
		road_colider[dir].enabled = false
		

func _enter_area(body: Node2D):
	if (body is not Player):
		return
	
	Event.on_change_room.emit(body.map_pos, room_position, self)
	body.map_pos = room_position
	
	if !is_visited:
		is_visited = true
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
