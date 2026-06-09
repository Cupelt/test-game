extends Node

@onready var ui = load("res://scene/ui/damage_counter_ui.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Event.on_attacked.connect(_on_hp_changed)

func _on_hp_changed(data: AttackInfo):
	if data.target is Player:
		return
	
	ObjectPool.spawn_object(ui, {
		"position" : data.target.global_position,
		"attack_info": data
		}, data.target)
