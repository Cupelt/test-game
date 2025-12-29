@abstract class_name AbstractRoom

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

## Implemtable Method
## 맵 생성의 실행 우선도 입니다. HIGHEST 라면 가장 먼저 실행됩니다.
func get_priority() -> RoomPriority:
	return RoomPriority.NORMAL

## Implemtable Method
## 방의 유형. 맵 생성시 참고 가능.
func get_map_type() -> MapType:
	return MapType.SPECIAL

## [method Abstract.is_before_generate()] 의 값이 true가 아니라면
## 리턴값과, pos 값은 쓰지 않는 값입니다.
@abstract func apply(map: Dictionary[Vector2i, AbstractRoom], pos: Vector2i) -> bool

## 이 값이 true 인 경우
## 맵을 생성할 때 apply를 참고하게 됩니다.
##
## 기본 apply 함수는 마지막에 딱 "한 번" 실행 되는 반면
## 이 값이 true 인 경우는 "매 번" 생성 가능 여부를 판별합니다.
func is_before_generate() -> bool:
	return false

#region Debug
func _get_display_char():
	return "#"
#endregion
