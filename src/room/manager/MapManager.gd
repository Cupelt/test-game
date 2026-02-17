extends Node2D
class_name MapManager

@export var room_generator: RoomGenerator
@export var room_registry: RoomRegistry
@export var tilemap_builder: TilemapBuilder

var current_map: MapData

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var map_data: Dictionary[Vector2i, AbstractRoom] = room_generator.generate()
	current_map = tilemap_builder.build_map(map_data)
	pass
