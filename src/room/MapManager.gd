
var map: Dictionary[Vector2i, AbstractRoom]

func generateRooms(roomCount: int, adjacentChance: float) -> void:
	map.clear()
	
	var walkHistory: Array[Vector2i] = [Vector2i(0, 0)]

	## 시작방은 항상 존재
	map[Vector2i(0, 0)] = null
	
	var currentPos;
	while map.size() < roomCount:
		currentPos = walkHistory.pick_random()
		
		var dirs = [Vector2i.UP, Vector2i.DOWN, Vector2i.LEFT, Vector2i.RIGHT]
		dirs.shuffle()
		
		var placed = false
		for d in dirs:
			var targetPos = currentPos + d
			
			# 이미 그 자리에 방이 있다면 생성 불가.
			if (map.has(targetPos)):
				continue
			
			if (RoomUtils.countAdjacentCount(map, targetPos) > 1 and randf_range(0, 1) > adjacentChance):
				continue
				
			walkHistory.append(targetPos)
			map[targetPos] = null
			
			placed = true
		
		if not placed:
			walkHistory.erase(currentPos)
			
		# 무한 루프 방지 (안전장치)
		if walkHistory.is_empty():
			break
	
