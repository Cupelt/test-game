@abstract class_name AbstractRoom

enum RoomPriority {
	HIGHEST,
	HIGH,
	NORMAL,
	LOW,
	LOWEST
}

@abstract func get_priority() -> RoomPriority
@abstract func is_special() -> bool
@abstract func apply(map: Dictionary[Vector2i, AbstractRoom]) -> void

#region Debug
func _get_display_char():
	return "#"
#endregion
