extends Node

@onready var ui = load("res://scene/ui/damage_counter_ui.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Event.on_hp_changed.connect(_on_hp_changed)

func _on_hp_changed(body: Node2D, before: float, after: float):
	ObjectPool.spawn_object(ui, {
		"position" : body.global_position,
		"damage" : roundi(before - after)
		}, body)
