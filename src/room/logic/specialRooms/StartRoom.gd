extends AbstractRoom
class_name StartRoom

var alreadyGenerated = false

func get_priority() -> RoomPriority:
	return RoomPriority.HIGHEST;

func is_before_generate() -> bool:
	return true

func is_special() -> bool:
	return true
	
func apply(map: Dictionary[Vector2i, AbstractRoom], pos: Vector2i) -> void:
	if !alreadyGenerated:
		return
	
	map[Vector2i(0, 0)] = self
	alreadyGenerated = true

func _get_display_char() -> String:
	return "S"
