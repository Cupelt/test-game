extends Control
class_name StatusIcon

var type: AttackType
var _origin_size: Vector2

func _ready() -> void:
	_origin_size = (get_child(0) as TextureRect).size

func init(data: Dictionary):
	type = data.type
	
	var status_texture = get_child(0) as TextureRect
	var texture = GradientTexture2D.new()
	var gradient = Gradient.new()
	var element_color = type.color
	gradient.set_color(0, element_color)
	gradient.set_color(1, element_color)
	
	texture.gradient = gradient
	texture.height = 512
	texture.width = 512
	
	status_texture.texture = texture
	status_texture.scale = Vector2.ONE
	status_texture.self_modulate = Color(1, 1, 1, 1)
