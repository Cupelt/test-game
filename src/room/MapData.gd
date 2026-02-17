class_name MapData

var _map_instances: Dictionary[Vector2i, RoomData]

func has_room(pos: Vector2i) -> bool:
	return _map_instances.has(pos)

func get_room(pos: Vector2i) -> RoomData:
	return _map_instances[pos]

func get_room_list() -> Array[RoomData]:
	return _map_instances.values()
