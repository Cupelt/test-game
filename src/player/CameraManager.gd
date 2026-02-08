extends Camera2D

var to: Vector2;
var camera_tween: Tween;

@export var BLEND_SPEED = 150;
@export var duration: float = 0.5;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	MapManager.Instance.on_change_room.connect(trasition)
	pass

func trasition(from: Vector2i, to: Vector2i):
	
	if camera_tween:
		camera_tween.kill()
		
	# MapManager.Instance.room_instances[to].visible = true
	
	camera_tween = create_tween()
	camera_tween.tween_property(self, 
			"global_position", 
			MapManager.Instance.room_pos_to_global_pos(to), 
			duration)\
		.set_trans(Tween.TRANS_CUBIC)\
		.set_ease(Tween.EASE_OUT)
	
	return
	
	await camera_tween.finished
	
	var instance_list = MapManager.Instance.room_instances
	for key in instance_list:
		var instance = instance_list[key] as Node2D
		instance.visible = key == to
