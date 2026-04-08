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
	
	var wiggle_pos = Vector2(randf_range(-wiggle_fector, wiggle_fector), 0)
	var tween = get_tree().create_tween()
	tween.tween_property(wiggle_body, "position", wiggle_pos, duration).as_relative()
	tween.set_ease(Tween.EASE_IN_OUT)
	
	tween.tween_callback(destroy_object)
