@abstract extends Resource
class_name Reaction

@export var id: StringName

@export var is_two_way = false
@export var source: AttackType
@export var trigger: AttackType

@abstract func apply_effect(data: AttackResult)

func can_reaction(_source: AttackType, _trigger: AttackType) -> bool:
	# 부착원소 -> 공격원소, 부착원소 <-> 공격원소 확인.
	if not ((_source.id == source.id and _trigger.id == trigger.id) or \
			(is_two_way and _source.id == trigger.id and _trigger.id == source.id)):
		return false
	
	# TODO: 원래 원소 부족할 때 검사 하려고 했는데 안쓸듯?
	return true

func get_consume_rate(_source: AttackType, _trigger: AttackType) -> float:
	return 1
