class_name RoomUtils

static func sampleOneAdjacentPos(map: Dictionary[Vector2i, AbstractRoom], include_special: bool):
	var copy = map.keys().duplicate_deep()
	copy.shuffle()
	
	for pos in copy:
		if (countAdjacentCount(map, pos) <= 1 
			and (include_special or map[pos] == null)):
			return pos
	
	return null

static func getAdjacentRooms(map: Dictionary[Vector2i, AbstractRoom], pos: Vector2i) -> Array[Vector2i]:
	var dirs: Array[Vector2i] = []
	for d in [Vector2i.UP, Vector2i.DOWN, Vector2i.LEFT, Vector2i.RIGHT]:
		if map.has(pos + d):
			dirs.append(d)
	return dirs

static func countAdjacentCount(map: Dictionary[Vector2i, AbstractRoom], pos: Vector2i) -> int:
	return getAdjacentRooms(map, pos).size()

static func printMapDebug(generated_room: Dictionary[Vector2i, AbstractRoom]):
	if generated_room.is_empty():
		print("맵이 비어 있습니다.")
		return

	# 1. 맵의 최소/최대 범위 계산 (Rect2i 활용)
	var min_pos = Vector2i(99999, 99999)
	var max_pos = Vector2i(-99999, -99999)
	
	for pos in generated_room.keys():
		min_pos.x = min(min_pos.x, pos.x)
		min_pos.y = min(min_pos.y, pos.y)
		max_pos.x = max(max_pos.x, pos.x)
		max_pos.y = max(max_pos.y, pos.y)

	print("--- Map Layout (Size: %d x %d) ---" % [max_pos.x - min_pos.x + 1, max_pos.y - min_pos.y + 1])

	# 2. Y축부터 반복하며 텍스트 맵 생성
	for y in range(min_pos.y, max_pos.y + 1):
		var line = ""
		for x in range(min_pos.x, max_pos.x + 1):
			var pos = Vector2i(x, y)
			if generated_room.has(pos):
				# 타입에 따라 다른 문자 출력 (enum 값에 맞춰 수정 가능)
				var room: AbstractRoom = generated_room[pos]
				line += " " + room._get_display_char() + " "
			else:
				line += " . " # 빈 공간
		print(line)
	print("---------------------------------")
