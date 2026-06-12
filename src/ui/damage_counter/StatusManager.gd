extends Node2D
class_name StatusManager

@export var stats: EntityStats
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
	stats.on_status_changed.connect(status_update)
	stats.on_reaction_triggered.connect(react_update)
	init()

func init():
	hp_prograss.init()
	
func status_update(old_status: AttackType, new_status: AttackType):
	_status_objects[0].visible = new_status != null
	
	if _status_objects[0].visible:
		_status_objects[0].texture = new_status.icon

func react_update(source: AttackType, trigger: AttackType, reaction: Reaction):
	if reaction:
		if source:
			_status_objects[0].texture = source.icon
		
		if trigger:
			_status_objects[1].texture = trigger.icon
		
		# TODO: Reaction Animation
	
