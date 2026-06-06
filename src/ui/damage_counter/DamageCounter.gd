extends Node

@onready var ui = load("res://scene/ui/damage_counter_ui.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Event.on_stats_changed.connect(_on_hp_changed)

func _on_hp_changed(body: Node2D, type: EntityStats.StatType, old_value: float, new_value: float):
	if body is Player:
		return
	
	if type != EntityStats.StatType.HP:
		return
	
	ObjectPool.spawn_object(ui, {
		"position" : body.global_position,
		"damage" : roundi(old_value - new_value)
		}, body)
