extends Node
class_name EntityStats

signal on_stats_changed(type: StatType, old_value: float, new_value: float)

enum StatType {
	MAX_HP, HP, HP_GENERATION,
	ATTACK, ATTACK_SPEED,
	SPEED
}

enum EffectType {
	PYRO,
	ICE,
	ELECTRIC,
	VOID,
}

@export var parent: Node2D
@export var base_stats: Dictionary[StatType, float]
var _stats: Dictionary[StatType, float]

var status_effects: Array[EffectType]

func _ready() -> void:
	reset()

func reset():
	_stats = base_stats.duplicate_deep()
	if _stats.has(StatType.MAX_HP) and (not _stats.has(StatType.HP) or base_stats[StatType.HP] <= 0):
		_stats[StatType.HP] = _stats[StatType.MAX_HP]

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
