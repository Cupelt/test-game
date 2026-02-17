extends AbstractRoom
class_name BossRoom

func get_priority() -> RoomPriority:
	return 9999 # 무조건 먼저 실행
	
func is_special() -> bool:
	return true

# 가장 먼 곳에 보스방 생성
func apply(map: Dictionary[Vector2i, AbstractRoom]) -> void:
	var furthestPos = RoomUtils.find_furthest_room_pos(map, false)
	map[furthestPos] = self;
	
func _get_display_char() -> String:
	return "B"
