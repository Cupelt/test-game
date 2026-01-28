extends AbstractRoom
class_name SingleRoom

func get_priority() -> RoomPriority:
	return -9999; # 무조건 마지막에 생성

func is_special() -> bool:
	return false
	
func apply(map: Dictionary[Vector2i, AbstractRoom]) -> void:
	for key in map:
		if map[key] == null:
			map[key] = self
	
func _get_display_char() -> String:
	return "#"
