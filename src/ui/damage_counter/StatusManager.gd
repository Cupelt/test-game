extends Node2D
class_name StatusManager

@export var stats: EntityStats
@export var default_status_icon: Texture2D

@onready var hp_prograss = $HpPrograssComponent
@onready var status = $status
@onready var anim: AnimationPlayer = $status/AnimationTree/AnimationPlayer
@onready var anim_tree = $status/AnimationTree
@onready var status_icon_scene = load("res://scene/ui/staus_icon.tscn")

@export var reaction_impect: GPUParticles2D

@onready var _status_objects: Array[Control] = [
	status.get_child(0),
	status.get_child(1)
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hp_prograss.stats = stats
	stats.on_attacked.connect(update)
	stats.on_reaction_triggered.connect(react_update)
	init()

func _process(delta: float) -> void:
	if (Input.is_key_pressed(KEY_F)):
		trigger_reaction_animation(0, 1, "test")

func init():
	hp_prograss.init()

func update(data: AttackResult):
	var icon_list = status.get_children()
	var has_icon: bool = icon_list.any(func(e):
		return data.attack_data.element_type.id == e.type.id
	)
		
	if has_icon:
		return

	var status_icon: StatusIcon = ObjectPool.spawn_object(status_icon_scene, {}, status)
	status_icon.type = data.attack_data.element_type
	
	var status_texture = status_icon.get_child(0) as TextureRect
	var texture = GradientTexture2D.new()
	var gradient = Gradient.new()
	var element_color = data.attack_data.element_type.color
	gradient.set_color(0, element_color)
	gradient.set_color(1, element_color)
	
	texture.gradient = gradient
	texture.height = 512
	texture.width = 512
	
	status_texture.texture = texture
	
	status_texture.scale = Vector2(1.5, 1.5)
	status_texture.self_modulate = Color(1, 1, 1, 0)
	
	var tween = create_tween().set_parallel(true)
	
	tween.tween_property(status_texture, "scale", Vector2.ONE, 0.2)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	tween.tween_property(status_texture, "self_modulate", Color(1, 1, 1, 1), 0.2)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)

func react_update(result: AttackResult, source: AttackType, trigger: AttackType, reaction: Reaction):
	if reaction:
		var icon_list = status.get_children()
		var source_node: bool = icon_list.find_custom(func(e):
			return data.attack_data.element_type.id == e.type.id
		)
		# TODO: 앞뒤 맞춰서 anim 실행

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
