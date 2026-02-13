@abstract extends Node2D
class_name AbstractRoom

enum RoomPriority {
	HIGHEST,
	HIGH,
	NORMAL,
	LOW,
	LOWEST
}

enum MapType {
	NORMAL,
	SPECIAL
}

@export var icon: Texture
@export var presets: Array[PackedScene]

## Implemtable Method
## 맵 생성의 실행 우선도 입니다. HIGHEST 라면 가장 먼저 실행됩니다.
func get_priority() -> RoomPriority:
	return RoomPriority.NORMAL

## Implemtable Method
## 방의 유형. 맵 생성시 참고 가능.
func get_map_type() -> MapType:
	return MapType.SPECIAL

@abstract func apply(map: Dictionary[Vector2i, AbstractRoom]) -> void

func render(layer: TileMapLayer, pos: Vector2i) -> void:
	var manager = MapManager.Instance
	
	var target_pos = pos * (manager.roomSize + Vector2i.ONE * manager.corridorSize * 2)
	layer.set_cell(target_pos, manager.sourceID, Vector2i(0, 0), manager.roomIDs[presets.pick_random()])
	layer.update_internals()
	
	var room_instance: RoomInfo = layer.get_child(layer.get_child_count() - 1)
	room_instance.room_position = pos
	
	manager.room_instances[pos] = room_instance
	
	var AdjacentDirs: Array[Vector2i] = RoomUtils.getAdjacentRooms(MapManager.Instance.map, pos)
	
	for dir in AdjacentDirs:
		var instance: Node2D = manager.corridor_scene.instantiate()
		manager.tilemap.add_child(instance)
		
		var offset: Vector2 = manager.roomSize * dir / 2.0
		var corridor_offset: Vector2 = dir * manager.corridorSize / 2.0

		instance.global_position = (target_pos as Vector2 + offset + corridor_offset + Vector2(-0.5, -0.5)) * 16
		
		if dir == Vector2i.LEFT:
			var left_node = room_instance.find_child("IsLeftBlocked")
			if left_node: left_node.queue_free()
			instance.find_child("Vertical").queue_free()
		elif dir == Vector2i.RIGHT:
			var right_node = room_instance.find_child("IsRightBlocked")
			if right_node: right_node.queue_free()
			instance.find_child("Vertical").queue_free()
		elif dir == Vector2i.UP:
			var up_node = room_instance.find_child("IsTopBlocked")
			if up_node: up_node.queue_free()
			instance.find_child("Horizontal").queue_free()
		elif dir == Vector2i.DOWN:
			var down_node = room_instance.find_child("IsDownBlocked")
			if down_node: down_node.queue_free()
			instance.find_child("Horizontal").queue_free()
			
	layer.update_internals()

#region Debug
func _get_display_char():
	return "#"
#endregion
