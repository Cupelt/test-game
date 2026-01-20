@tool
extends MapManager

@export var generators: Array[Script] = []:
	set(value):
		generators = value
		_generators = value
		notify_property_list_changed()
@export_category("ㅡㅡㅡㅡㅡㅡㅡㅡㅡ[ Room Presets ]ㅡㅡㅡㅡㅡㅡㅡㅡㅡ")

func _get_property_list() -> Array[Dictionary]:
	var properties: Array[Dictionary] = []
	
	for room in generators:
		properties.append({
			"name": room.get_global_name() as String,
			"type": TYPE_ARRAY,
			"hint_string": "RoomPrefab"
		})
	
	properties.append({
		"name": "StartRoom",
		"type": TYPE_ARRAY,
		"hint_string": "RoomPrefab"
	})
	# print(_presets)
	return properties

func _get(property: StringName):
	if generators.any(
		func (e: Script): 
			return (e.get_global_name() as String) == property
	):
		if (!_presets.has(property as String)):
			_presets[property as String] = []
			
		return _presets[property as String]
		
func _set(property: StringName, value: Variant) -> bool:	
	if generators.any(
		func (e: Script): 
			return (e.get_global_name() as String) == property
	):
		_presets[property as String] = value
		if ((value as Array).size() <= 0):
			_presets.erase(property as String)
		return true
	return false
