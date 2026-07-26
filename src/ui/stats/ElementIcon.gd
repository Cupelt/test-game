extends Control
class_name StatusIcon

var type: AttackType
var stats: EntityStats
var _origin_size: Vector2

var blink_tween: Tween

func _ready() -> void:
	var status_texture = get_child(0) as TextureRect
	_origin_size = (get_child(0) as TextureRect).size
	
	blink_tween = create_tween().set_loops()
	blink_tween.set_trans(Tween.TRANS_SINE)
	blink_tween.set_ease(Tween.EASE_IN_OUT)
	
	blink_tween.tween_property(status_texture, "self_modulate:a", 0.0, 0.5)
	blink_tween.tween_property(status_texture, "self_modulate:a", 1.0, 0.5)
	blink_tween.pause()

func init(data: Dictionary):
	type = data.type
	stats = data.stats
	
	var status_texture = get_child(0) as TextureRect
	
	status_texture.texture = type.icon
	status_texture.scale = Vector2.ONE
	status_texture.self_modulate = Color(1, 1, 1, 1)
	
	var color: Color
	if type is ElementType:
		color = type.color
	else:
		color = Color.WHITE
	(status_texture.material as ShaderMaterial).set_shader_parameter("line_color", color.darkened(0.5))
	(status_texture.material as ShaderMaterial).set_shader_parameter("line_thickness", 0)

func _process(delta: float) -> void:
	var left_time = stats.get_element_left_duration(type)
	if left_time > 3:
		blink_tween.pause()
	else:
		blink_tween.play()
