extends Node2D
class_name StatusManager

@export var stats: EntityStats
@export var default_status_icon: Texture2D

@onready var hp_prograss = $HpPrograssComponent
@onready var status = $status
@onready var anim: AnimationPlayer = $status/AnimationTree/AnimationPlayer
@onready var anim_tree = $status/AnimationTree

@export var reaction_impect: GPUParticles2D

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

	var pos_a = node_a.global_position
	var pos_b = node_b.global_position
	var center_pos = (pos_a + pos_b) / 2

	for child in icon_container:
		if child != node_a and child != node_b:
			var tween_fade = create_tween()
			tween_fade.tween_property(child, "modulate:a", 0.3, 0.15)
			tween_fade.tween_property(child, "modulate:a", 1.0, 0.15)\
				.set_delay(reaction_anim_delay)
	
	var tween = create_tween().set_parallel(true)
	
	var nodes = [node_a, node_b]
	var positions = [pos_a, pos_b]

	# 1. 반동 애니메이션 (동시 실행)
	for i in range(2):
		var node = nodes[i]
		var start_pos = positions[i]
		var backstep_pos = start_pos - start_pos.direction_to(center_pos) # 15픽셀 정도 밀려나게 조절
		
		tween.tween_property(node, "global_position", backstep_pos, 0.13)\
			.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

	# 순차 진행을 위해 체인 연결 (set_parallel 상태이므로 이후 등록되는 트윈들이 동시에 실행됨)
	tween.chain()

	# 2. 충돌 애니메이션 (동시 실행)
	for node in nodes:
		tween.tween_property(node, "global_position", center_pos, 0.07)\
			.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)

	# 3. 마무리 및 파티클 방출
	tween.chain().tween_callback(func():
		node_a.global_position = pos_a
		node_b.global_position = pos_b
		
		# Transform2D 구조에 맞게 생성 (회전, 크기, 왜곡, 위치 순서)
		var xform = Transform2D(0.0, Vector2.ONE, 0.0, center_pos)
		reaction_impect.emit_particle(xform, Vector2.ZERO, Color.WHITE, Color.WHITE, 0)
	)

func create_projectile_effect(node: Control, start_pos: Vector2, end_pos: Vector2) -> Tween: 
	var tween = create_tween().set_parallel(true)
	
	var img_node = node.get_node("image")
	# 반동
	tween.tween_property(img_node, "global_position", start_pos - start_pos.direction_to(end_pos), 0.13)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	
	# Impect
	tween.tween_property(img_node, "global_position", end_pos, 0.2 - 0.13)\
		.set_delay(0.13)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)

	tween.tween_callback(func():
		img_node.global_position = start_pos
	)
	
	#tween.chain().tween_callback(func():
		## 파티클 방출 (track 3)
		#var xform = Transform2D(Vector2(20, 1), Vector2(30, 1), Vector2(0, 0))
		#particles.emit_particle(xform, Vector2(0, 0), Color(1, 1, 1, 1), Color(1, 1, 1, 1), 0)
	#)
	
	return tween
