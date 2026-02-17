extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _left_fog(from, to: Vector2i):
	self.scale = Vector2.ONE	
	self.visible = true
	
	var cutter_tween = create_tween()
	cutter_tween.tween_property(self, "scale", Vector2(15, 15), 2)\
		.set_trans(Tween.TRANS_CUBIC)\
		.set_ease(Tween.EASE_OUT)
	
	await cutter_tween.finished
	
	# var instance: RoomData = MapManager.Instance.room_instances[to]
	# instance.
