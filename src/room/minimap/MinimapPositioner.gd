extends Control

@export var manager: MinimapManager
@export var BLEND_SPEED: float = 150

var to: Vector2

func _ready() -> void:
	MapManager.Instance.on_change_room.connect(update_room)

func _process(delta: float) -> void:
	position = position.lerp(-to, pow(0.5, delta * BLEND_SPEED))

func update_room(from: Vector2i, to: Vector2i):
	self.to = manager.roomSize * (to as Vector2)
