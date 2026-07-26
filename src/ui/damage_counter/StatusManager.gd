extends Node2D
class_name StatusManager

@export var stats: EntityStats
@export var default_status_icon: Texture2D

@export var hp_prograss: HpViewComponent
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
		

func status_append(type: AttackType, duration: float):
	if icons.has(type.id):
		return

	var status_icon: StatusIcon = ObjectPool.spawn_object(status_icon_scene, {"type": type, "stats": stats}, status)
	icons[type.id] = status_icon

	var status_texture = status_icon.get_child(0) as TextureRect
	status_texture.scale = Vector2(1.5, 1.5)
	status_texture.self_modulate = Color(1, 1, 1, 0)
	
	var append_tween = create_tween().set_parallel(true)
	append_tween.tween_property(status_texture, "scale", Vector2.ONE, 0.2)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	append_tween.tween_property(status_texture, "self_modulate", Color(1, 1, 1, 1), 0.2)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)

func react_update(result: AttackResult, source: AttackType, trigger: AttackType, reaction: Reaction):
	if reaction:
		var source_node = icons[source.id]
		var trigger_node: StatusIcon = ObjectPool.spawn_object(status_icon_scene, {"type": trigger, "stats": stats}, status)
		
		trigger_reaction_animation_2(source_node.get_index())
		trigger_reaction_animation_2(trigger_node.get_index())
		
		#trigger_reaction_animation(
			#min(source_node.get_index(), trigger_node.get_index()),
			#max(source_node.get_index(), trigger_node.get_index()),
			#reaction
		#)
		
		await _reaction_tween.finished
		ObjectPool.destroy_object(trigger_node)

var reaction_anim_delay = 0.4

func trigger_reaction_animation_2(index: int):
	var icon_container = $status.get_children()
	var node: Control = icon_container[index]
	var texture_node: Control = node.get_child(0)
	
	_reaction_tween = create_tween().set_parallel(true)
	_reaction_tween.tween_property(texture_node, "position", Vector2(0, -10), reaction_anim_delay * 0.7)\
			.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)\
			.as_relative()
	
	_reaction_tween.chain()
	
	_reaction_tween.tween_property(texture_node, "scale", Vector2(0, 12.5), reaction_anim_delay * 0.3)\
			.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	_reaction_tween.tween_property(texture_node, "self_modulate:a", 0.0, reaction_anim_delay * 0.3)\
		.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
		
	_reaction_tween.chain().tween_callback(func (): texture_node.position = Vector2.ZERO)
