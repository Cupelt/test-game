extends AbstractRoom
class_name TreasureRoom

func get_priority() -> RoomPriority:
	return RoomPriority.HIGH;

func is_special() -> bool:
	return true
	
func apply(map: Dictionary[Vector2i, AbstractRoom]) -> void:
	var furthestPos = RoomUtils.sample_one_adjacent_pos(map, false)
	map[furthestPos] = self

func _get_display_char() -> String:
	return "$"
