extends TextureRect
class_name MinimapHover

@export var minimap: Control
@export var roomPrefab: PackedScene
@export var blindRoomPrefab: PackedScene
@export var roomSize: Vector2 = Vector2()

@export_range(0, 1, 0.1) var MAX_OPACITY: float = 1.0
@export_range(0, 1, 0.1) var MIN_OPACITY: float = 0.4

@export var BLEND_SPEED: float = 150
var to: float;

func _ready() -> void:
	modulate.a = MIN_OPACITY
	to = MIN_OPACITY
	
	mouse_entered.connect(func (): to = MAX_OPACITY)
	mouse_exited.connect(func (): to = MIN_OPACITY)

func _process(delta: float) -> void:
	modulate.a = lerpf(modulate.a, to, pow(0.5, delta * BLEND_SPEED))
	minimap.position = minimap.position.lerp(
		roomSize * (MapManager.Instance.currentPlayerPos as Vector2), 
		pow(0.5, delta * BLEND_SPEED))
	
func build_minimap(map: Dictionary[Vector2i, AbstractRoom]) -> void:
	# clear minimap
	for node in minimap.get_children():
		node.queue_free()
	
	for pos in map:
		var room: Control = roomPrefab.instantiate(PackedScene.GEN_EDIT_STATE_MAIN)
		# (room.get_child(0) as TextureRect).texture = map[pos].icon
		minimap.add_child(room)
		
		room.position = room.position + roomSize * (pos as Vector2)
	
