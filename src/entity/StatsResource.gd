extends Resource
class_name StatsResource

signal on_stats_changed(type: StatType, old_value: float, new_value: float)

enum StatType {
	MAX_HP, HP, HP_GENERATION,
	ATTACK, ATTACK_SPEED,
	SPEED
}

@export_group("Stats")
@export var _stats: Dictionary[StatType, float]

func set_stats(type: StatType, value: float):
	_stats[type] += value

func set_stat_list(stats: Dictionary[StatType, float]):
	var old
	
	for k in stats:
		on_stats_changed.emit(k, stats[k])
	on_stats_changed.emit(_stats.duplicate_deep(), stats.duplicate_deep())
	_stats.assign(stats)

func add_stats(stats: Dictionary[StatType, float]):
	var final_stats = _stats.duplicate_deep()
	for key in stats:
		final_stats[key] = final_stats.get(key, 0) + stats[key]
	
	set_stats(final_stats)

func get_stat(type: StatType) -> float:
	return _stats.get(type, 0)
