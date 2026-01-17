extends AbstractRoom
class_name LargeRoom

# 넓은방은 맵 생성에 전반적인 영향을 줌.
func get_priority() -> RoomPriority:
	return RoomPriority.HIGHEST;
	
func is_special() -> bool:
	return false

func is_before_generate() -> bool:
	return true

func apply(map: Dictionary[Vector2i, AbstractRoom]) -> void:
	var check_offsets = [
		Vector2i(-1, -1),
		Vector2i(0, -1),
		Vector2i(-1, 0),
		Vector2i(0, 0)
	]
	
	check_offsets.shuffle()
	
	for target in map.keys():
		for offset in check_offsets:
			var topLeft = target + offset
			
			var cases = [
				topLeft,
				topLeft + Vector2i(1, 0),
				topLeft + Vector2i(0, 1),
				topLeft + Vector2i(1, 1)
			]
			
			# 2x2 가 아닌경우
			var canMerge = cases.all(func(p): 
				return map.has(p) and RoomGenerator.Instance.isDefaultRoom(p)
			)
			
			if (canMerge):
				for p in cases:
					map[p] = self
					
				break

func _get_display_char() -> String:
	return "■"
