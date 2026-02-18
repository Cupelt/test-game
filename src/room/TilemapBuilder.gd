extends Node2D
class_name TilemapBuilder

@export var tilemap: TileMapLayer
@export var minimap_manager: MinimapManager
@export var nav_region: NavigationRegion2D

@export_category("Ingame Elements")
@export var fog_buffer: BackBufferCopy

@export_category("Positional Options")
@export var room_size: Vector2i = Vector2i(31, 17)
@export var rendering_quadrant_size: int = 16

var source_id: int = -1;
var _room_id: Dictionary[PackedScene, int]
var isInitalized = false

func load_tilemap(rooms: Array[AbstractRoom]) -> void:
	var collection: TileSetScenesCollectionSource = TileSetScenesCollectionSource.new()
	for gen in rooms:
		for scene in gen.presets:
			# 생성된 TileSetScenesCollectionSource 의 아이디에 대응 하는 RoomData를 저장
			_room_id[scene] = collection.create_scene_tile(scene)
	
	source_id = tilemap.tile_set.add_source(collection)
	
	isInitalized = true

func build_map(map: Dictionary[Vector2i, AbstractRoom]) -> MapData:
	var map_data = MapData.new()
	
	# register buleprint
	for pos in map:
		map_data._map_instances[pos] = null
	
	# instantiate map
	for pos in map:
		var instance: RoomData = _render(map_data, map[pos], pos)
		map_data._map_instances[pos] = instance
		
	minimap_manager.build_minimap(map)
	nav_region.bake_navigation_polygon()
	
	return map_data

func _render(map_data: MapData, type: AbstractRoom, pos: Vector2i) -> RoomData:
	var target_pos = pos * (room_size + Vector2i.ONE) * rendering_quadrant_size 
	
	var sampled_scene: PackedScene = type.sample_room()
	var room_instance: RoomData = sampled_scene.instantiate()
	tilemap.add_child(room_instance)
	
	room_instance.room_position = pos
	room_instance.global_position = target_pos
	room_instance.init(pos, type, RoomUtils.get_adjacent_directions(map_data._map_instances, pos))
	
	room_instance.fog_instnace = room_instance.fog_scene.instantiate()
	room_instance.fog_instnace.global_position = target_pos
	fog_buffer.add_child(room_instance.fog_instnace)
	
	type.post_process(map_data, room_instance)
	
	return room_instance
	
