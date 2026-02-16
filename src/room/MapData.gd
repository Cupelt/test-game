class_name MapData

var _map: Dictionary[Vector2i, RoomData]
var visitedPos: Array[Vector2i]

func has_room(pos: Vector2i) -> bool:
	return _map.has(pos)

func get_room(pos: Vector2i) -> RoomData:
	return _map[pos]

func get_room_list() -> Array[RoomData]:
	return _map.values()

func findFurthestRoomPos(include_special: bool) -> Vector2i:
	var furthestPos: Vector2i = Vector2i(-1, -1)
	var maxDistance: int = -1
	
	for pos in _map:
		if include_special or _map[pos] != null:
			continue
			
		if countAdjacentCount(pos) > 1:
			continue
			
		var distance = abs(pos.x) + abs(pos.y)
		
		if distance > maxDistance:
			maxDistance = distance
			furthestPos = pos
			
	return furthestPos

func sampleOneAdjacentPos(include_special: bool):
	var copy = _map.keys().duplicate_deep()
	copy.shuffle()
	
	for pos in copy:
		if (countAdjacentCount(pos) <= 1 
			and (include_special or _map[pos] == null)):
			return pos
	
	return null

func getAdjacentRooms(pos: Vector2i) -> Array[Vector2i]:
	var dirs: Array[Vector2i] = []
	for d in [Vector2i.UP, Vector2i.DOWN, Vector2i.LEFT, Vector2i.RIGHT]:
		if _map.has(pos + d):
			dirs.append(d)
	return dirs

func countAdjacentCount(pos: Vector2i) -> int:
	return getAdjacentRooms(pos).size()
