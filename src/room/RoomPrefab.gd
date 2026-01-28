@tool
extends Resource
class_name RoomPrefab

@export var roomScene: Array[PackedScene] # Room Scene
@export_range(0, 100) var spawnWeight: float = 10.0 # 생성 확률 (가중치)
