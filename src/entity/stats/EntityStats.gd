extends Node
class_name EntityStats

signal on_stats_changed(type: StatType, old_value: float, new_value: float)
signal on_attacked(data: AttackInfo)
signal on_reaction_triggered(source: AttackType, trigger: AttackType, reaction: Reaction)
signal on_status_changed(old_status: AttackType, new_status: AttackType)

enum StatType {
	MAX_HP, HP, HP_GENERATION,
	ATTACK, ATTACK_SPEED,
	SPEED
}

@export var parent: Entity
@export var base_stats: Dictionary[StatType, float]
var _stats: Dictionary[StatType, float]

var status_effect: AttackType

func _ready() -> void:
	reset()

func reset():
	_stats = base_stats.duplicate_deep()
	if _stats.has(StatType.MAX_HP) and (not _stats.has(StatType.HP) or base_stats[StatType.HP] <= 0):
		_stats[StatType.HP] = _stats[StatType.MAX_HP]

func give_damage(data: AttackInfo):
	if parent.is_die:
		return
	
	data.target = parent
	
	on_attacked.emit(data)
	Event.on_attacked.emit(data)
	
	var before_status = status_effect
	var reaction: Reaction = ReactionManager.get_reaction(status_effect, data.type)
	if reaction:
		reaction.apply_effect(data)
		status_effect = reaction.get_next_element(status_effect, data.type) 
		on_reaction_triggered.emit(reaction, data.damage)
	else:
		status_effect = data.type
	
	if before_status != status_effect:
		on_status_changed.emit(before_status, status_effect)
	
	add_stats(EntityStats.StatType.HP, -data.damage)


func set_stats(type: StatType, value: float):
	var old_value = get_stat(type)
	_stats[type] = value
	on_stats_changed.emit(type, old_value, value)
	Event.on_stats_changed.emit(parent, type, old_value, value)

func add_stats(type: StatType, value: float):
	set_stats(type, get_stat(type) + value)
	
func set_stats_list(stats: Dictionary[StatType, float]):
	var old_stats = _stats.duplicate_deep()
	_stats.assign(stats)
	
	for k in stats:
		on_stats_changed.emit(k, old_stats[k], stats[k])
		Event.on_stats_changed.emit(parent, k, old_stats[k], stats[k])
	
func add_stats_list(stats: Dictionary[StatType, float]):
	var final_stats = _stats.duplicate_deep()
	for key in stats:
		final_stats[key] = final_stats.get(key, 0) + stats[key]
	
	set_stats_list(final_stats)

func get_stat(type: StatType) -> float:
	return _stats.get(type, 0)
