extends Node2D
class_name StatusManager

@export var stats: EntityStats
@export var default_status_icon: Texture2D

@onready var hp_prograss = $HpPrograssComponent
@onready var status = $status
@onready var anim: AnimationPlayer = $status/AnimationTree/AnimationPlayer
@onready var anim_tree = $status/AnimationTree

@onready var _status_objects: Array[Control] = [
	status.get_child(0),
	status.get_child(1)
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	return
	hp_prograss.stats = stats
	stats.on_status_changed.connect(status_update)
	stats.on_reaction_triggered.connect(react_update)
	init()

func _process(delta: float) -> void:
	if (Input.is_key_pressed(KEY_F)):
		trigger_reaction_animation(0, 1, "test")

func init():
	hp_prograss.init()
	
func status_update(old_status: AttackType, new_status: AttackType):	
	if anim.is_playing():
		await anim.animation_finished
		if new_status != stats.status_effect:
			return

	if new_status != null:
		_status_objects[0].get_child(0).texture = new_status.icon
		anim_tree["parameters/has_element/transition_request"] = "true"
		anim_tree["parameters/change_element/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE
	else:
		anim_tree["parameters/has_element/transition_request"] = "false"

func react_update(result: AttackResult, source: AttackType, trigger: AttackType, reaction: Reaction):
	if reaction:
		if source:
			_status_objects[0].get_child(0).texture = source.icon
		
		if trigger:
			_status_objects[1].get_child(0).texture = trigger.icon
		
		anim_tree["parameters/react/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE
		

const ELEMENT_COLORS = {
	0: Color(0.2, 0.6, 1.0),
	1: Color(1.0, 0.3, 0.1),
	2: Color(0.3, 0.1, 0.5)
}

var reaction_anim_delay = 0.2

func trigger_reaction_animation(elem_a: int, elem_b: int, reaction_text: String):
	var icon_container = $status.get_children()
	var node_a = icon_container[elem_a]
	var node_b = icon_container[elem_b]
	
	if not node_a or not node_b: return

	# 1. 두 아이콘의 현재 글로벌 위치 구하기 (중간에 암흑이 있어도 정확한 좌표를 가져옴)
	var pos_a = node_a.global_position + (node_a.size / 2)
	var pos_b = node_b.global_position + (node_b.size / 2)
	var center_pos = (pos_a + pos_b) / 2

	# 2. 반응에 참여하지 않는 원소들(예: 암흑) 투명화 처리 (Staging)
	for child in icon_container:
		if child != node_a and child != node_b:
			var tween_fade = create_tween()
			tween_fade.tween_property(child, "modulate:a", 0.3, 0.15)
			tween_fade.tween_property(child, "modulate:a", 1.0, 0.15)\
				.set_delay(reaction_anim_delay)

	# 3. 선 연결 및 충돌 애니메이션 (Tween 활용)
	create_projectile_effect(node_a, pos_a, center_pos)
	create_projectile_effect(node_b, pos_b, center_pos)

func create_projectile_effect(node: Control, start_pos: Vector2, end_pos: Vector2):
	var tween = create_tween().set_parallel(true)
	
	var img_node = node.get_node("image")
	var after_node = node.get_node("image/after")
	node.position
	#tween.parallel().tween_property(
			#node.get_node("image"), 
			#"position:y", -5, 
			#reaction_anim_delay
		#)\
		#.set_ease(Tween.EASE_OUT)\
		#.set_trans(Tween.TRANS_CUBIC)
	#tween.parallel().tween_property(
			#node.get_node("image/after"), 
			#"scale", Vector2.ONE * 1.8, 
			#reaction_anim_delay / 2
		#)\
		#.set_ease(Tween.EASE_IN)
	#
	#tween.tween_property(
			#node.get_node("image/after"), 
			#"scale", Vector2.ONE * 1, 
			#reaction_anim_delay / 2
		#)\
		#.set_ease(Tween.EASE_OUT)
	#
	#tween.tween_property(node.get_node("image"), "modulate:a", 0, 0.15)\
		#.set_delay(reaction_anim_delay)

	# 반동
	tween.tween_property(img_node, "position", Vector2(-1, 0), 0.13)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	
	# Inpect
	tween.tween_property(img_node, "position", end_pos, 0.2 - 0.13)\
		.set_delay(0.13333334)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)

	#tween.chain().tween_callback(func():
		## 파티클 방출 (track 3)
		#var xform = Transform2D(Vector2(20, 1), Vector2(30, 1), Vector2(0, 0))
		#particles.emit_particle(xform, Vector2(0, 0), Color(1, 1, 1, 1), Color(1, 1, 1, 1), 0)
	#)
