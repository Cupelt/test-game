extends Node2D

@export var MAX_SCALE = 10

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Event.on_change_room.connect(_left_fog)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _left_fog(from: Vector2i, to: Vector2i, instance: RoomData):
	var cutter_tween = create_tween()
	cutter_tween.tween_property(self, "scale", Vector2.ONE * MAX_SCALE, 1)\
		.set_trans(Tween.TRANS_CUBIC)\
		.set_ease(Tween.EASE_OUT)
	
	await cutter_tween.finished
	
	self.scale = Vector2.ONE
	instance.fog_instnace.visible = false
