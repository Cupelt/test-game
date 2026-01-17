extends Node2D
class_name RoomGenerator

static var Instance: RoomGenerator

var map: Dictionary[Vector2i, AbstractRoom]

var _defaultRoom: AbstractRoom = SingleRoom.new()
var _rooms: Array[AbstractRoom] = [
	BossRoom.new(),
	TreasureRoom.new(),
	LargeRoom.new()
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
	
func build(layer: TileMapLayer) -> void:
	for pos in map:
		map[pos].render(layer, pos);

func generateMap(roomCount: int, adjacentChance: float) -> void:
	map.clear()
	# var generators: Dictionary[AbstractRoom.ApplyPoint, Array]

	#for r in _rooms:
		#generators[r.get_apply_point()].append(r);
	
	
	var walkHistory: Array[Vector2i] = [Vector2i(0, 0)]

	## 시작방은 항상 존재
	map[Vector2i(0, 0)] = StartRoom.new()
	
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
	
	#for room in generators[AbstractRoom.ApplyPoint.ON_POST]:
		#(room as AbstractRoom).apply(map)
		
	_rooms.sort_custom(
		func (a: AbstractRoom, b: AbstractRoom): 
			return a.get_priority() < b.get_priority()
	)
	
	for room in _rooms:
		room.apply(map)
	
	RoomUtils.printMapDebug(map)
