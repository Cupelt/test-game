extends AbstractRoom
class_name SingleRoom

func get_priority() -> RoomPriority:
	return -9999;

func is_special() -> bool:
	return false
	
func apply(map: Dictionary[Vector2i, AbstractRoom]) -> void:
	# hard coded
	pass

func _get_display_char() -> String:
	return "#"
