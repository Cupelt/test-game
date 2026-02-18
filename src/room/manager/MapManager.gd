extends Node2D
class_name MapManager

@export var room_generator: RoomGenerator
@export var tilemap_builder: TilemapBuilder

var current_map: MapData

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var map_data: Dictionary[Vector2i, AbstractRoom] = room_generator.generate()
	
	tilemap_builder.load_tilemap(room_generator._generators)
	current_map = tilemap_builder.build_map(map_data)
	pass
