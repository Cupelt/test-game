extends AbstractRoom
class_name SingleRoom

func get_priority() -> RoomPriority:
	return RoomPriority.HIGHEST;
	
func is_special() -> bool:
	return false

func apply(map: Dictionary[Vector2i, AbstractRoom], pos: Vector2i) -> void:
	pass
	
func _get_display_char() -> String:
	return "#"
