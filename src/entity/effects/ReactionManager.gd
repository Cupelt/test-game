extends Node

@onready var reactions: Array[Reaction] = [
	load("res://settings/effects/reactions/Vaporize.tres")
]

var reaction_map: Dictionary[Reaction.AttackType, Dictionary]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for effect in reactions: # TODO: 고치기
		reaction_map.get_or_add(effect.source, {})[effect.trigger] = effect
	
	reaction_map.make_read_only()
	
