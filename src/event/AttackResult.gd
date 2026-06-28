extends RefCounted
class_name AttackResult

var attack_data: AttackData

var damage: float = 0;
var is_crit: bool = false
var is_reacted: bool: 
	get: return !_reactions.is_empty()
var _reactions: Array[Reaction]

func _init(_attack_data: AttackData):
	attack_data = _attack_data
	damage = attack_data.damage
