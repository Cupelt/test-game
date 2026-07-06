extends Control
class_name StatusIcon

var type: AttackType
var _origin_size: Vector2

func _ready() -> void:
	_origin_size = (get_child(0) as TextureRect).size

func init(data: Dictionary):
	type = data.type
	
	var status_texture = get_child(0) as TextureRect
	
	status_texture.texture = type.icon
	status_texture.scale = Vector2.ONE
	status_texture.self_modulate = Color(1, 1, 1, 1)
