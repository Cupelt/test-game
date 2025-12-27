extends AbstractRoom

# 보스방이 없으면 다음 스테이지로 갈 수 없음. (우선도 가장 높음)
func get_priority() -> RoomPriority:
	return RoomPriority.HIGH;
	
func is_special() -> bool:
	return true

# 가장 먼 곳에 보스방 생성
func apply(map: Dictionary[Vector2i, AbstractRoom]) -> void:
	var furthestPos = RoomUtils.findFurthestRoomPos(map, false)
	map[furthestPos] = self;
	
