@abstract extends Resource
class_name Reaction

@export var id: StringName

@export var is_two_way = false
@export var source: AttackType
@export var trigger: AttackType

@abstract func apply_effect(data: AttackInfo)

func can_reaction(_source: AttackType, _trigger: AttackType) -> bool:
	return (_source.id == source.id and _trigger.id == trigger.id) or \
	   (is_two_way and _source.id  == trigger.id  and _trigger.id  == source.id )

func get_consume_rate(_source: AttackType, _trigger: AttackType) -> float:
	return 1
