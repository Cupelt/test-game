extends RefCounted
class_name AttackInfo

var attacker: Entity # Nullable
var target: Entity

var damage: float
var type: Reaction.AttackType

func _init(_attacker: Node2D, 
		_type: Reaction.AttackType, 
		_damage: float,
		_apply_randomize: bool = true) -> void:
	attacker = _attacker
	damage = _damage * MathHelper.randomize_damage_factor()
	type = _type
