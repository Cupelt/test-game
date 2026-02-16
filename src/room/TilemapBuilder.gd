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
	map_data._map = map
	
	# for pos in map:
		
		# map[pos].render(tilemap, pos)
	minimap_manager.build_minimap(map)
	nav_region.bake_navigation_polygon()
	
	return MapData.new()

func _rander(map_data: MapData, pos: Vector2i, type: AbstractRoom) -> RoomData:
	var target_pos = pos * (room_size + Vector2i.ONE * corridor_size * 2) * rendering_quadrant_size 
	
	var sampled_scene: PackedScene = type.sample_room()
	var room_instance: RoomData = sampled_scene.instantiate()	
	room_instance.room_position = pos
	tilemap.add_child(room_instance)
	
	var adjacent_dirs: Array[Vector2i] = map_data.getAdjacentRooms(pos)
	
	for dir in adjacent_dirs:
		var instance: Node2D = corridor_scene.instantiate()
		tilemap.add_child(instance)
		
		var offset: Vector2 = room_size * dir / 2.0
		var corridor_offset: Vector2 = dir * corridor_size / 2.0

		instance.global_position = (target_pos as Vector2 + offset + corridor_offset + Vector2(-0.5, -0.5)) * 16
		
		if dir == Vector2i.LEFT:
			var left_node = room_instance.find_child("IsLeftBlocked")
			if left_node: left_node.queue_free()
		elif dir == Vector2i.RIGHT:
			var right_node = room_instance.find_child("IsRightBlocked")
			if right_node: right_node.queue_free()
		elif dir == Vector2i.UP:
			var up_node = room_instance.find_child("IsTopBlocked")
			if up_node: up_node.queue_free()
		elif dir == Vector2i.DOWN:
			var down_node = room_instance.find_child("IsDownBlocked")
			if down_node: down_node.queue_free()
	
	return room_instance
	
