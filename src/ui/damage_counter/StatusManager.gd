extends Node2D
class_name StatusManager

@export var stats: EntityStats
@export var default_status_icon: Texture2D

@onready var hp_prograss = $HpPrograssComponent
@onready var status = $status
@onready var anim = $status/AnimationTree/AnimationPlayer
@onready var anim_tree = $status/AnimationTree

@onready var _status_objects: Array[Control] = [
	status.get_child(0),
	status.get_child(1)
]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hp_prograss.stats = stats
	stats.on_status_changed.connect(status_update)
	stats.on_reaction_triggered.connect(react_update)
	init()

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

func react_update(source: AttackType, trigger: AttackType, reaction: Reaction):
	if reaction:
		if source:
			_status_objects[0].get_child(0).texture = source.icon
		
		if trigger:
			_status_objects[1].get_child(0).texture = trigger.icon
		
		anim_tree["parameters/react/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE
	
