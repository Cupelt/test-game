extends Node2D
class_name MapManager

static var Instance: MapManager;

@export_category("Tilemap Setting")
@export var tilemap: TileMapLayer
@export_category("Generator Setting")
@export var generator: RoomGenerator
@export var rooms: Array[RoomPrefab]
var sourceID: int;
var roomIDs: Dictionary[RoomPrefab, int]

@export var generateSeed: int = 0
@export var maxRoom: int = 10
@export var roomSize: Vector2i = Vector2i(33, 19)
@export_range(0, 0.2) var adjacentChance = 0.04

var currentPlayerPos: Vector2i = Vector2i(0, 0)

func global_pos_to_room_pos(pos: Vector2) -> Vector2i:
	var default_room_size: Vector2 = roomSize * tilemap.rendering_quadrant_size
	
	return (pos / default_room_size).round() * Vector2(-1, -1)

func room_pos_to_global_pos(pos: Vector2i) -> Vector2:
	var default_room_size: Vector2 = roomSize * tilemap.rendering_quadrant_size
	return default_room_size * (pos as Vector2) * Vector2(-1, -1)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if (Instance != null):
		queue_free();
		return
	
	Instance = self
	
	var collection: TileSetScenesCollectionSource = TileSetScenesCollectionSource.new()
	for r in rooms:
		# 생성된 TileSetScenesCollectionSource 의 아이디에 대응 하는 RoomData를 저장
		roomIDs[r] = collection.create_scene_tile(r.roomScene)
	
	sourceID = tilemap.tile_set.add_source(collection)
	
	## 랜덤시드 재설정
	randomize()
	
	## 시드가 지정되어 있다면 해당 시드로 생성
	if (generateSeed != 0):
		seed(generateSeed)
		
	generator.generateMap(maxRoom, adjacentChance)
	generator.build(tilemap)
