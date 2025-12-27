extends AbstractRoom

func get_priority() -> RoomPriority:
	return RoomPriority.HIGH;

func is_special() -> bool:
	return true
	
# 가장 먼 곳에 보스방 생성
func apply(map: Dictionary[Vector2i, AbstractRoom]) -> void:
	var furthestPos = RoomUtils.findOneAdjacentPos(map, false)
	map[furthestPos] = self;
