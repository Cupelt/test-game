extends Node2D
class_name StatusManager

@export var stats: EntityStats
@export var status_icons: Dictionary[Reaction.AttackType, Texture2D] 
@export var default_status_icon: Texture2D

@onready var hp_prograss = $HpPrograssComponent
@onready var status = $status

@onready var _status_objects: Array[TextureRect] = [
	status.get_child(0),
	status.get_child(1)
]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hp_prograss.stats = stats
	stats.on_reacted.connect(status_update)
	init()

func init():
	hp_prograss.init()
	
func status_update(old_status: Reaction.AttackType, new_status: Reaction.AttackType):
	_status_objects[0].visible = new_status != Reaction.AttackType.NONE
	
	if _status_objects[0].visible:
		_status_objects[0].texture = status_icons.get(new_status, default_status_icon)

func react_update(source: Reaction.AttackType, trigger: Reaction.AttackType, reaction: Reaction):
	if reaction:
		_status_objects[0].visible = true
		_status_objects[0].texture = status_icons.get(source, default_status_icon)
		
		_status_objects[1].visible = true
		_status_objects[1].texture = status_icons.get(trigger, default_status_icon)
		
		# TODO: Reaction Animation
	
