extends TileMapLayer

@export var rooms: Array[RoomData]
var sourceID: int;
var roomIDs: Dictionary[RoomData, int]

@export var generateSeed: int = 0
# @export_range(0, 1, 0.01) var roomGenerateRate: float = 0.5
@export var maxRoom: int = 10
var generatedRoom: Dictionary[Vector2i, RoomData.RoomType]

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
		
	generateRooms()

func generateRooms() -> void:
	var walkHistory: Array[Vector2i] = [Vector2i(0, 0)]
	
	## 시작방은 항상 존재
	var currentPos = Vector2i(0, 0)
	generatedRoom[currentPos] = RoomData.RoomType.Start
	
	while generatedRoom.size() < maxRoom:
		currentPos = walkHistory.pick_random()
		
		var dirs = [Vector2i.UP, Vector2i.DOWN, Vector2i.LEFT, Vector2i.RIGHT]
		dirs.shuffle()
		
		var placed = false
		for d in dirs:
			var targetPos = currentPos + d
			
			# 이미 그 자리에 방이 있다면 생성 불가.
			if (generatedRoom.has(targetPos)):
				continue
			
			if (countAdjacentCount(targetPos) > 1):
				continue
			
			walkHistory.append(targetPos)
			generatedRoom[targetPos] = RoomData.RoomType.Room
			placed = true
			break
		
		if not placed:
			walkHistory.erase(currentPos)
			
		# 무한 루프 방지 (안전장치)
		if walkHistory.is_empty():
			break
		
	printMapDebug(generatedRoom)

func countAdjacentCount(pos: Vector2i) -> int:
	var count = 0
	var dirs = [Vector2i.UP, Vector2i.DOWN, Vector2i.LEFT, Vector2i.RIGHT]
	for d in dirs:
		if generatedRoom.has(pos + d):
			count += 1
	return count
	

func printMapDebug(generated_room: Dictionary):
	if generated_room.is_empty():
		print("맵이 비어 있습니다.")
		return

	# 1. 맵의 최소/최대 범위 계산 (Rect2i 활용)
	var min_pos = Vector2i(99999, 99999)
	var max_pos = Vector2i(-99999, -99999)
	
	for pos in generated_room.keys():
		min_pos.x = min(min_pos.x, pos.x)
		min_pos.y = min(min_pos.y, pos.y)
		max_pos.x = max(max_pos.x, pos.x)
		max_pos.y = max(max_pos.y, pos.y)

	print("--- Map Layout (Size: %d x %d) ---" % [max_pos.x - min_pos.x + 1, max_pos.y - min_pos.y + 1])

	# 2. Y축부터 반복하며 텍스트 맵 생성
	for y in range(min_pos.y, max_pos.y + 1):
		var line = ""
		for x in range(min_pos.x, max_pos.x + 1):
			var pos = Vector2i(x, y)
			if generated_room.has(pos):
				# 타입에 따라 다른 문자 출력 (enum 값에 맞춰 수정 가능)
				var type = generated_room[pos]
				line += _get_room_char(type)
			else:
				line += " . " # 빈 공간
		print(line)
	print("---------------------------------")

# RoomType enum에 따른 문자 매칭 함수
func _get_room_char(type: RoomData.RoomType) -> String:
	match type:
		RoomData.RoomType.Start: 	return " S "
		RoomData.RoomType.Boss:  	return " B "
		RoomData.RoomType.Treasure:	return " $ "
		_: return " # " # 일반 방
