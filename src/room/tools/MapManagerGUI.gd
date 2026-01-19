@tool
extends MapManager

func _get_property_list() -> Array[Dictionary]:
	var properties: Array[Dictionary] = []
	var generator: Array[AbstractRoom] = [
		BossRoom.new(),
		TreasureRoom.new(),
		LargeRoom.new()
	]
	
	print(generator.size())
	for room in generator:
		properties.append({
			"name": room.get_class(),
			"type": TYPE_BOOL,
			"usage": PROPERTY_USAGE_DEFAULT
		})
	return properties
