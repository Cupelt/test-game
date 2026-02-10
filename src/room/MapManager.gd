extends Node2D
class_name MapManager

static var Instance: MapManager;

@export_category("Default Setting")
@export var player: Player

@export_category("Tilemap Setting")
@export var tilemap: TileMapLayer
@export var minimap: MinimapManager
@export var nav_region: NavigationRegion2D
@export var corridor_scene: PackedScene
@export_category("Generator Setting")
var _generators: Array[AbstractRoom]

var sourceID: int;
var roomIDs: Dictionary[PackedScene, int]

@export var generateSeed: int = 0
@export var maxRoom: int = 10
@export var roomSize: Vector2i = Vector2i(33, 19)
@export var corridorSize: int = 7
@export_range(0, 0.2) var adjacentChance = 0.04

var currentPlayerPos: Vector2i = Vector2i.MAX

var map: Dictionary[Vector2i, AbstractRoom]
var visitedPos: Array[Vector2i]
var room_instances: Dictionary[Vector2i, Node2D]

signal on_change_room(from: Vector2i, to: Vector2i)

func global_pos_to_room_pos(pos: Vector2) -> Vector2i:
	var default_room_size: Vector2 = roomSize * tilemap.rendering_quadrant_size
	
	return (pos / default_room_size).round()# * Vector2(1, -1)

func room_pos_to_global_pos(pos: Vector2i) -> Vector2:
	var default_room_size: Vector2 = roomSize * tilemap.rendering_quadrant_size
	return default_room_size * (pos as Vector2)# * Vector2(1, -1)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# 싱글톤 생성
	if (Instance != null):
		queue_free();
		return
	
	Instance = self
	
	# generator 등록
	for node in get_children():
		_generators.append(node as AbstractRoom)
	
	_generators.sort_custom(
		func (a: AbstractRoom, b: AbstractRoom): 
			return a.get_priority() > b.get_priority()
	)
	
	# Tileset 등록
	var collection: TileSetScenesCollectionSource = TileSetScenesCollectionSource.new()
	for gen in _generators:
		for scene in gen.presets:
			# 생성된 TileSetScenesCollectionSource 의 아이디에 대응 하는 RoomData를 저장
			roomIDs[scene] = collection.create_scene_tile(scene)
	
	sourceID = tilemap.tile_set.add_source(collection)
	
	## 랜덤시드 재설정
	randomize()
	
	## 시드가 지정되어 있다면 해당 시드로 생성
	if (generateSeed != 0):
		seed(generateSeed)
		
	generateMap()
	build()

func _process(delta: float) -> void:
	var afterPos = global_pos_to_room_pos(player.global_position)
	if (currentPlayerPos != afterPos):
		on_change_room.emit(currentPlayerPos, afterPos)
		
		currentPlayerPos = afterPos
		visitedPos.append(afterPos)

func build() -> void:
	for pos in map:
		map[pos].render(tilemap, pos)
	minimap.build_minimap(map)
	nav_region.bake_navigation_polygon()
	

func generateMap() -> void:
	map.clear()
	var walkHistory: Array[Vector2i] = [Vector2i(0, 0)]

	## 시작방은 항상 존재
	map[Vector2i(0, 0)] = StartRoom.new()
	
	var currentPos;
	while map.size() < maxRoom:
		currentPos = walkHistory.pick_random()
		
		var dirs = [Vector2i.UP, Vector2i.DOWN, Vector2i.LEFT, Vector2i.RIGHT]
		dirs.shuffle()
		
		var placed = false
		for d in dirs:
			var targetPos = currentPos + d
			
			# 이미 그 자리에 방이 있다면 생성 불가.
			if (map.has(targetPos)):
				continue
			
			if (RoomUtils.countAdjacentCount(map, targetPos) > 1 and randf_range(0, 1) > adjacentChance):
				continue
			
			walkHistory.append(targetPos)
			map[targetPos] = null
			
			placed = true
		
		if not placed:
			walkHistory.erase(currentPos)
			
		# 무한 루프 방지 (안전장치)
		if walkHistory.is_empty():
			break
	
	#for room in generators[AbstractRoom.ApplyPoint.ON_POST]:
		#(room as AbstractRoom).apply(map)
	
	for room in _generators:
		room.apply(map)

	RoomUtils.printMapDebug(map)
