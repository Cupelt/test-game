extends TileMapLayer

@export var rooms: Array[RoomPrefab]
var sourceID: int;
var roomIDs: Dictionary[RoomPrefab, int]

@export var generateSeed: int = 0
# @export_range(0, 1, 0.01) var roomGenerateRate: float = 0.5
@export var maxRoom: int = 10
@export var roomSize: Vector2i = Vector2i(33, 19)
@export_range(0, 0.2) var adjacentChance = 0.04

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var collection: TileSetScenesCollectionSource = TileSetScenesCollectionSource.new()
	for r in rooms:
		# 생성된 TileSetScenesCollectionSource 의 아이디에 대응 하는 RoomData를 저장
		roomIDs[r] = collection.create_scene_tile(r.roomScene)
	
	sourceID = tile_set.add_source(collection)
	
	## 랜덤시드 재설정
	randomize()
	
	## 시드가 지정되어 있다면 해당 시드로 생성
	if (generateSeed != 0):
		seed(generateSeed)
		
	MapManager.generate(maxRoom, adjacentChance)
