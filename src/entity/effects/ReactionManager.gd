extends Node

@onready var reactions: Array[Reaction] = [
	load("res://settings/effects/reactions/Vaporize.tres")
]

var _reaction_map: Dictionary[Reaction.AttackType, Dictionary]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for effect in reactions:
		_reaction_map.get_or_add(effect.source, {})[effect.trigger] = effect

func get_reaction(source: Reaction.AttackType, trigger: Reaction.AttackType) -> Reaction:
	return _reaction_map.get(source, {}).get(trigger, null)
