extends ObjectPool
class_name DamageUI

# TODO animation
@export var anim: AnimationPlayer
@export var label: Label
@export var wiggle_body: Node2D

@export var wiggle_fector: float = 10
@export var duration: float = 0.5;

var completion_count = 0

func init(data: Dictionary):
	global_position = data["position"]
	label.text = format_with_commas(data["damage"])
	completion_count = 0
	pass
	
func _enter_tree() -> void: # after loaded
	anim.play("play")
	anim.animation_finished.connect(func(_name): check_complete(), CONNECT_ONE_SHOT)
	# anim.get_animation("play").track_set_key_value(0, 2, randf_range(-wiggle_fector, wiggle_fector))
	
	var wiggle_pos = Vector2(randf_range(-wiggle_fector, wiggle_fector), 0)
	wiggle_body.position = Vector2.ZERO
	
	var tween = get_tree().create_tween()
	tween.tween_property(wiggle_body, "position", wiggle_pos, duration).as_relative() \
		.set_ease(Tween.EASE_OUT) \
		.set_trans(Tween.TRANS_CUBIC)
		
	tween.tween_callback(check_complete)
	
func check_complete():
	completion_count += 1
	if completion_count >= 2:
		destroy_object()

func format_with_commas(value: int) -> String:
	var num_str = str(value)
	var result = ""
	var length = num_str.length()
	
	for i in range(length):
		if i > 0 and (length - i) % 3 == 0:
			result += ","
		result += num_str[i]
		
	return result
