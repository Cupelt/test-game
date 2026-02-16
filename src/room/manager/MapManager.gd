extends Node2D
class_name MapManager

@export var room_generator: RoomGenerator
@export var room_registry: RoomRegistry
@export var tilemap_builder: TilemapBuilder

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var map_data: Dictionary[Vector2i, AbstractRoom] = room_generator.generate()
	pass
