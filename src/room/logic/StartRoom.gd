extends AbstractRoom
class_name StartRoom

func get_priority() -> RoomPriority:
	return 999999; # 무조건 존재

func is_special() -> bool:
	return true
	
func apply(map: Dictionary[Vector2i, AbstractRoom]) -> void:
	map[Vector2i(0, 0)] = self

func _get_display_char() -> String:
	return "S"
