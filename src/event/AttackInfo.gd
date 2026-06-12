extends RefCounted
class_name AttackInfo

var attacker: Entity # Nullable
var target: Entity

var damage: float
var element_type: ElementType
var weapon_type: WeaponType

func _init(_attacker: Node2D, 
		_damage: float,
		_weapon_type: WeaponType,
		_element_type: ElementType = null,
		_apply_randomize: bool = true) -> void:
	attacker = _attacker
	damage = _damage * MathHelper.randomize_damage_factor()
	element_type = _element_type
	weapon_type = _weapon_type
