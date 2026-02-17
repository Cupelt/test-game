extends Node2D
class_name TilemapBuilder

@export var tilemap: TileMapLayer
@export var minimap_manager: MinimapManager
@export var nav_region: NavigationRegion2D
@export var corridor_scene: PackedScene

@export_category("Positional Options")
@export var room_size: Vector2i = Vector2i(31, 17)
@export var corridor_size: int = 7
@export var rendering_quadrant_size: int = 16

func build_map(map: Dictionary[Vector2i, AbstractRoom]) -> MapData:
	var map_data = MapData.new()
	
	# register buleprint
	for pos in map:
		map_data._map_instances[pos] = null
	
	# instantiate map
	for pos in map:
		var instance: RoomData = _render(map_data, map[pos], pos)
		map_data._map[pos] = instance
		
	minimap_manager.build_minimap(map)
	nav_region.bake_navigation_polygon()
	
	return map_data

func _render(map_data: MapData, type: AbstractRoom, pos: Vector2i) -> RoomData:
	var target_pos = pos * (room_size + Vector2i.ONE * corridor_size * 2) * rendering_quadrant_size 
	
	var sampled_scene: PackedScene = type.sample_room()
	var room_instance: RoomData = sampled_scene.instantiate()	
	room_instance.room_position = pos
	room_instance.global_position = target_pos
	room_instance.init(pos, type, RoomUtils.get_adjacent_directions(map_data._map_instances, pos))
	
	tilemap.add_child(room_instance)
	type.post_process(map_data, room_instance)
	
	return room_instance
	
