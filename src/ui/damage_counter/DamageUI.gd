extends ObjectPool
class_name DamageUI

# TODO animation
@export var anim: AnimationPlayer
@export var label: Label
@export var wiggle_body: Node2D

@export var wiggle_fector: float = 10
@export var duration: float = 0.5;

func init(data: Dictionary):
	global_position = data["position"]
	label.text = str(data["damage"])
	pass
	
func _enter_tree() -> void: # after loaded
	anim.play("play")
	# anim.get_animation("play").track_set_key_value(0, 2, randf_range(-wiggle_fector, wiggle_fector))
	
	var wiggle_pos = Vector2(randf_range(-wiggle_fector, wiggle_fector), 0)
	wiggle_body.position = Vector2.ZERO
	
	var tween = get_tree().create_tween()
	tween.tween_property(wiggle_body, "position", wiggle_pos, duration).as_relative() \
		.set_ease(Tween.EASE_OUT) \
		.set_trans(Tween.TRANS_CUBIC)
	
	tween.tween_callback(destroy_object)
