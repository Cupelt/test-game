extends Node2D
class_name GoldEntity

@export var anim_tree: AnimationTree

@export var gold: int = 1
var is_taken = false

func init(data: Dictionary):
	gold = data.gold
	global_position = data.position
	is_taken = false
	pass
	
func _enter_tree() -> void:
	anim_tree["parameters/spawn/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE
	
func _process(delta: float) -> void:
	if is_taken:
		return

	if GlobalContainer.player.global_position.distance_to(global_position) < 50:
		is_taken = true
		take_gold(GlobalContainer.player)
		

func take_gold(player: Player):
	var direction = global_position.direction_to(player.global_position)
	
	var tween = get_tree().create_tween()
	tween.tween_property(self, "global_position", -direction * 10, 0.2)\
		.set_ease(Tween.EASE_OUT)\
		.set_trans(Tween.TRANS_CUBIC)\
		.as_relative()
	
	tween.tween_method(
		func(weight: float):
			if is_instance_valid(player):
				# 현재 위치에서 플레이어의 '실시간' 위치로 보간
				global_position = global_position.lerp(player.global_position, weight),
		0.0, 1.0, 0.3
	).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	
	tween.tween_callback(func (): 
		player.gold += gold
		ObjectPool.safe_destroy_object(self)
	)
	
