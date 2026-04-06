extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Event.on_hp_changed.connect(_on_hp_changed)

func _on_hp_changed(body: Node2D, before: float, after: float):
