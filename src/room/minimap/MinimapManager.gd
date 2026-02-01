extends Control
class_name MinimapManager

@export var minimap: Control
@export var roomPrefab: PackedScene
@export var roomSize: Vector2

var minimap_objects: Dictionary[Vector2i, MinimapObject]

func _ready() -> void:
	MapManager.Instance.on_change_room.connect(visit_map)

func visit_map(from: Vector2i, to: Vector2i):
	if (!minimap_objects.has(to)):
		push_warning("cannot fount " + str(to) + " in minimap_objects")
		return;
	
	minimap_objects[to].set_icon_visible(false)
	if (minimap_objects.has(from)):
		minimap_objects[from].set_icon_visible(true)
	
	minimap_objects[to].update_room(MinimapObject.MinimapState.VISITED)
	# print("---------------")
	for d in [Vector2i.UP, Vector2i.DOWN, Vector2i.LEFT, Vector2i.RIGHT]:
		var target = (to + d)
		if (!minimap_objects.has(target)):
			continue
		
		# print(target, minimap_objects[target].state)
		
		if (minimap_objects[target].state == MinimapObject.MinimapState.BLINDED):
			minimap_objects[target].update_room(MinimapObject.MinimapState.NO_VISIT)
	

func build_minimap(map: Dictionary[Vector2i, AbstractRoom]) -> void:
	# clear minimap
	for node in minimap.get_children():
		node.queue_free()
	
	for pos in map:
		var room: MinimapObject = roomPrefab.instantiate(PackedScene.GEN_EDIT_STATE_MAIN)
		minimap.add_child(room)
		
		room.icon.texture = map[pos].icon
		room.position = room.position + roomSize * (pos as Vector2)
		
		minimap_objects[pos] = room
