extends Node2D
class_name StatusManager

@export var stats: EntityStats
@export var default_status_icon: Texture2D

@onready var hp_prograss = $HpPrograssComponent
@onready var status: HBoxContainer = $status
# @onready var anim: AnimationPlayer = $status/AnimationTree/AnimationPlayer
# @onready var anim_tree = $status/AnimationTree
@onready var status_icon_scene = load("res://scene/ui/staus_icon.tscn")

@export var reaction_impect: GPUParticles2D

var icons: Dictionary[StringName, Control]
var _reaction_tween: Tween

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hp_prograss.stats = stats
	stats.on_status_append.connect(status_append)
	stats.on_status_remove.connect(status_remove)
	stats.on_reaction_triggered.connect(react_update)
	init()

func init():
	hp_prograss.init()
	
func status_remove(type: AttackType):
	if icons.has(type.id):
		var node = icons[type.id]
		icons.erase(type.id)
		
		if _reaction_tween and _reaction_tween.is_running():
			await _reaction_tween.finished
		
		ObjectPool.destroy_object(node)
		print("removed")
		

func status_append(type: AttackType, duration: float):
	if icons.has(type.id):
		return

	var status_icon: StatusIcon = ObjectPool.spawn_object(status_icon_scene, {"type": type}, status)
	icons[type.id] = status_icon

	var status_texture = status_icon.get_child(0) as TextureRect
	status_texture.scale = Vector2(1.5, 1.5)
	status_texture.self_modulate = Color(1, 1, 1, 0)
	
	var append_tween = create_tween().set_parallel(true)
	append_tween.tween_property(status_texture, "scale", Vector2.ONE, 0.2)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	append_tween.tween_property(status_texture, "self_modulate", Color(1, 1, 1, 1), 0.2)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	
	print("appended")

func react_update(result: AttackResult, source: AttackType, trigger: AttackType, reaction: Reaction):
	if reaction:
		var source_node = icons[source.id]
		var trigger_node: StatusIcon = ObjectPool.spawn_object(status_icon_scene, {"type": trigger}, status)
		
		trigger_reaction_animation_2(source_node.get_index())
		trigger_reaction_animation_2(trigger_node.get_index())
		
		#trigger_reaction_animation(
			#min(source_node.get_index(), trigger_node.get_index()),
			#max(source_node.get_index(), trigger_node.get_index()),
			#reaction
		#)
		
		await _reaction_tween.finished
		ObjectPool.destroy_object(trigger_node)

var reaction_anim_delay = 0.2

func trigger_reaction_animation_2(index: int):
	var icon_container = $status.get_children()
	var node: Control = icon_container[index]
	var texture_node: Control = node.get_child(0)
	
	#_reaction_tween = create_tween() # 순차 진행을 위해 기본은 세로형(시퀀스)으로 생성
	#
	## 1단계: 꾹 눌리는 준비 동작 (Squash) - 아주 빠르게
	#_reaction_tween.tween_property(texture_node, "scale", Vector2(1.3, 0.7), reaction_anim_delay * 0.3)\
		#.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		#
	## 2단계: 팍! 늘어나며 사라지는 동작 (Stretch & Fade) - 동시에 실행
	#_reaction_tween.chain().set_parallel(true)
	#_reaction_tween.tween_property(texture_node, "scale", Vector2(0.0, 12.0), reaction_anim_delay * 0.7)\
		#.set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_IN) # 더 날카로운 QUART 사용
	#_reaction_tween.tween_property(texture_node, "self_modulate:a", 0.0, reaction_anim_delay * 0.7)\
		#.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	
	_reaction_tween = create_tween().set_parallel(true)
	_reaction_tween.tween_property(texture_node, "scale", Vector2(0, 12.5), reaction_anim_delay)\
			.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	_reaction_tween.tween_property(texture_node, "self_modulate:a", 0.0, reaction_anim_delay)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)

func trigger_reaction_animation(elem_a: int, elem_b: int, reaction: Reaction):
	var icon_container = $status.get_children()
	var node_a: Control = icon_container[elem_a]
	var node_b: Control = icon_container[elem_b]
	
	if not node_a or not node_b: return
	
	_reaction_tween = create_tween().set_parallel(true)
	await get_tree().process_frame

	var pos_a = node_a.position
	var pos_b = node_b.position
	var center_pos = (pos_a + pos_b) / 2

	for child in icon_container:
		if child != node_a and child != node_b:
			var tween_fade = create_tween()
			tween_fade.tween_property(child, "self_modulate:a", 0.3, 0.15)
			tween_fade.tween_property(child, "self_modulate:a", 1.0, 0.15)\
				.set_delay(reaction_anim_delay)
	
	var nodes = [node_a.get_child(0), node_b.get_child(0)]
	var positions = [pos_a, pos_b]

	# 1. 반동 애니메이션 (동시 실행)
	for i in range(2):
		var node = nodes[i]
		var start_pos = positions[i]
		var backstep_pos = -start_pos.direction_to(center_pos) * 5
		
		_reaction_tween.tween_property(node, "position", backstep_pos, reaction_anim_delay * 0.65)\
			.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

	# 순차 진행을 위해 체인 연결 (set_parallel 상태이므로 이후 등록되는 트윈들이 동시에 실행됨)
	_reaction_tween.chain()

	# 2. 충돌 애니메이션 (동시 실행)
	for i in range(2):
		var node = nodes[i]
		var start_pos = positions[i]
		var realative_pos = center_pos - start_pos
		_reaction_tween.tween_property(node, "position", realative_pos, reaction_anim_delay * 0.35)\
			.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)

	# 3. 마무리 및 파티클 방출
	_reaction_tween.chain().tween_callback(func():
		node_a.get_child(0).position = Vector2.ZERO
		node_b.get_child(0).position = Vector2.ZERO
		
		# Transform2D 구조에 맞게 생성 (회전, 크기, 왜곡, 위치 순서)
		var xform = Transform2D(0.0, Vector2.ONE, 0.0, center_pos)
		reaction_impect.emit_particle(xform, Vector2.ZERO, Color.WHITE, Color.WHITE, 0)
	)
