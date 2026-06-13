extends Node

@onready var reactions: Array[Reaction] = [
	load("res://settings/effects/reactions/Vaporize.tres")
]

var _reaction_map: Dictionary[StringName, Dictionary]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for effect in reactions:
		_reaction_map.get_or_add(effect.source.id, {})[effect.trigger.id] = effect
		if effect.is_two_way:
			_reaction_map.get_or_add(effect.trigger.id, {})[effect.source.id] = effect

func get_reaction(source: AttackType, trigger: AttackType) -> Reaction:
	if !source or !trigger:
		return
	return _reaction_map.get(source.id, {}).get(trigger.id, null)
