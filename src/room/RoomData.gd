extends Resource
class_name RoomData

enum RoomType {
	Start,
	Room,
	Treasure,
	Boss
}

@export var roomScene: PackedScene # Room Scene
@export var roomType: RoomType = RoomType.Room # 방 유형
@export_range(0, 100) var spawnWeight: float = 10.0 # 생성 확률 (가중치)
