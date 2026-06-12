extends RefCounted
class_name AttackInfo

var attacker: Entity # Nullable
var target: Entity

var damage: float
var type: AttackType

func _init(_attacker: Node2D, 
		_type: AttackType, 
		_damage: float,
		_apply_randomize: bool = true) -> void:
	attacker = _attacker
	damage = _damage * MathHelper.randomize_damage_factor()
	type = _type
