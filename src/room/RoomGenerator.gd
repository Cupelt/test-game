extends Node2D
class_name RoomGenerator

static var Instance: RoomGenerator

var map: Dictionary[Vector2i, AbstractRoom]

var _defaultRoom: AbstractRoom = SingleRoom.new()
var _rooms: Array[AbstractRoom] = [
	BossRoom.new(),
	TreasureRoom.new(),
	LargeRoom.new(),
	StartRoom.new()
]

func _ready() -> void:
	if (Instance != null):
		queue_free();
		return
	
	Instance = self

func getDefaultRoom() -> AbstractRoom:
	return _defaultRoom
	
func isDefaultRoom(pos: Vector2i) -> bool:
	return map[pos] == _defaultRoom;

func generateMap(roomCount: int, adjacentChance: float) -> void:
	map.clear()
	var beforeGenerate: Array[AbstractRoom] = []
	var afterGenerate: Array[AbstractRoom] = []

	_rooms.sort_custom(
		func (a: AbstractRoom, b: AbstractRoom): 
			return a.get_priority() < b.get_priority()
	)

	for r in _rooms:
		if r.is_before_generate():
			beforeGenerate.append(r)
		else:
			afterGenerate.append(r)
	
	
	var walkHistory: Array[Vector2i] = [Vector2i(0, 0)]

	## 시작방은 항상 존재
	map[Vector2i(0, 0)] = _defaultRoom
	
	var currentPos;
	while map.size() < roomCount:
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
			map[targetPos] = _defaultRoom
			
			placed = true
		
		if not placed:
			walkHistory.erase(currentPos)
			
		# 무한 루프 방지 (안전장치)
		if walkHistory.is_empty():
			break
	
	for pos in map:
		for room in afterGenerate:
			room.apply(map, pos)
	
	RoomUtils.printMapDebug(map)
