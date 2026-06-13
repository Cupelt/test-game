extends ObjectPool
class_name DamageUI

# TODO animation
@export var anim: AnimationPlayer
@export var label: Label
@export var wiggle_body: Node2D

@export var wiggle_fector: Vector2 = Vector2(10, 20)
static var damage_memory: float

var completion_count = 0

func init(data: Dictionary):
	global_position = data["position"]
	
	var info = data["attack_info"]
	label.text = format_with_commas(roundi(info.damage))
	# TODO: 반응 텍스트 띄우기
	
	var color: Color
	if info.element_type:
		color = info.element_type.color
	else:
		color = Color.WHITE
	label.label_settings.font_color = color
	
	completion_count = 0
	pass
	
func _enter_tree() -> void: # after loaded
	var animation = anim.get_animation("play_3")
	
	anim.play("play_3")
	anim.animation_finished.connect(func(_name): check_complete(), CONNECT_ONE_SHOT)
	# anim.get_animation("play").track_set_key_value(0, 2, randf_range(-wiggle_fector, wiggle_fector))
	
	var wiggle_pos = Vector2(
		randf_range(-wiggle_fector.x, wiggle_fector.x), 
		randf_range(0, wiggle_fector.y)
		)
	wiggle_body.position = Vector2.ZERO
	
	var tween = get_tree().create_tween()
	tween.tween_property(wiggle_body, "position", wiggle_pos, 0).as_relative() \
		.set_ease(Tween.EASE_OUT) \
		.set_trans(Tween.TRANS_CUBIC)
		
	tween.tween_callback(check_complete)
	
func check_complete():
	completion_count += 1
	if completion_count >= 2:
		ObjectPool.safe_destroy_object(self)

func format_with_commas(value: int) -> String:
	var num_str = str(value)
	var result = ""
	var length = num_str.length()
	
	for i in range(length):
		if i > 0 and (length - i) % 3 == 0:
			result += ","
		result += num_str[i]
		
	return result
