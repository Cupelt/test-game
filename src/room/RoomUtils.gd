class_name RoomUtils

static func findFurthestRoomPos(map: Dictionary[Vector2i, AbstractRoom], include_special: bool) -> Vector2i:
	var furthestPos: Vector2i = Vector2i(-1, -1)
	var maxDistance: int = -1
	
	for pos in roomArray:
		# 조건 1: 이미 큰 방(Big_Room)이거나 시작방이면 제외
		if generatedRoom[pos] != RoomData.RoomType.Room:
			continue
			
		# 조건 2: 막다른 길인지 체크 (선택 사항: 보스방이 구석에 있게 하려면 유지)
		if countAdjacentCount(pos) > 1:
			continue
			
		# 맨해튼 거리 계산: |x1 - x2| + |y1 - y2|
		var distance = abs(pos.x) + abs(pos.y)
		
		if distance > maxDistance:
			maxDistance = distance
			furthestPos = pos
			
	return furthestPos

func findOneAdjacentPos(map: Dictionary[Vector2i, AbstractRoom], include_special: bool):
	var copy = roomArray.duplicate_deep()
	
	if (isShuffle):
		copy.shuffle()
	
	for pos in copy:
		if countAdjacentCount(pos) <= 1 and generatedRoom[pos] == RoomData.RoomType.Room:
			return pos
	
	return null

func countAdjacentCount(map: Dictionary[Vector2i, AbstractRoom], pos: Vector2i) -> int:
	var count = 0
	var dirs = [Vector2i.UP, Vector2i.DOWN, Vector2i.LEFT, Vector2i.RIGHT]
	for d in dirs:
		if map.has(pos + d):
			count += 1
	return count

func printMapDebug(generated_room: Dictionary):
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
				var type = generated_room[pos]
				line += _get_room_char(type)
			else:
				line += " . " # 빈 공간
		print(line)
	print("---------------------------------")

# RoomType enum에 따른 문자 매칭 함수
func _get_room_char(type: RoomData.RoomType) -> String:
	match type:
		RoomData.RoomType.Start: 	return " S "
		RoomData.RoomType.Big_Room:	return " @ "
		RoomData.RoomType.Boss:  	return " B "
		RoomData.RoomType.Treasure:	return " $ "
		_: return " # " # 일반 방
