@abstract extends Resource
class_name Reaction

# 1XXX -> 원소 타입
# 2XXX -> 무기 타입
enum AttackType {
	PYRO = 1000,
	WATER = 1001,
	ICE = 1002,
	ELECTRIC = 1003,
	VOID = 1099,
	
	PROJECTILE = 2000,
	GREAT_SWORD = 2001
}

@export var id: StringName

@export var is_two_way = false
@export var source: AttackType
@export var trigger: AttackType

@abstract func apply_effect(attacker: Node2D, target: Node2D, base_damage: float) -> float

func can_reaction(_source: AttackType, _trigger: AttackType) -> bool:
	return (_source == source and _trigger == trigger) or \
	   (is_two_way and _source == trigger and _trigger == source)

static func is_element_type(type: AttackType) -> bool:
	return type < 2000
	
static func is_weapon_type(type: AttackType) -> bool:
	return type >= 2000

static func get_element_types() -> Array[AttackType]:
	return AttackType.values().filter(is_element_type)

static func get_weapon_types() -> Array[AttackType]:
	return AttackType.values().filter(is_weapon_type)
