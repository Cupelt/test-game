@abstract extends Node2D
class_name AbstractRoom

enum RoomPriority {
	HIGHEST,
	HIGH,
	NORMAL,
	LOW,
	LOWEST
}

enum MapType {
	NORMAL,
	SPECIAL
}

@export var icon: Texture
@export var presets: Array[PackedScene]

## Implemtable Method
## 맵 생성의 실행 우선도 입니다. HIGHEST 라면 가장 먼저 실행됩니다.
func get_priority() -> RoomPriority:
	return RoomPriority.NORMAL

## Implemtable Method
## 방의 유형. 맵 생성시 참고 가능.
func get_map_type() -> MapType:
	return MapType.SPECIAL

@abstract func apply(map: Dictionary[Vector2i, AbstractRoom]) -> void

func sample_room() -> PackedScene:
	return presets.pick_random()

func post_process(map_data: MapData, room_instance: RoomData):
	pass

#region Debug
func _get_display_char():
	return "#"
#endregion
