extends Node2D
class_name RoomGenerator

var _generators: Array[AbstractRoom]
@export var seed: String
@export var maxRoom: int = 10
@export_range(0, 0.2) var adjacentChance = 0.04

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for node in get_children():
		_generators.append(node as AbstractRoom)
	
	_generators.sort_custom(
		func (a: AbstractRoom, b: AbstractRoom): 
			return a.get_priority() > b.get_priority()
	)
	
	if (seed.is_empty()): 	randomize()
	else: 					seed(seed.to_upper().hash())

func generate() -> Dictionary[Vector2i, AbstractRoom]:
	var map: Dictionary[Vector2i, AbstractRoom]
	
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
	return map
