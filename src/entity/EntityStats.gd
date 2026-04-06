extends Node
class_name EntityStats

signal on_hp_changed(before: float, after: float)
signal on_stats_changed(before: Dictionary[StatType, float], after: Dictionary[StatType, float])

@export var base_stats: Dictionary[StatType, float]
var _stats: Dictionary[StatType, float]

func reset():
	_stats = base_stats.duplicate_deep()

func set_stats(stats: Dictionary[StatType, float]):
	_stats.assign(stats)
	on_stats_changed.emit(_stats.duplicate_deep(), stats.duplicate_deep())

func add_stats(stats: Dictionary[StatType, float]):
	var final_stats = _stats.duplicate_deep()
	for key in stats:
		final_stats[key] = final_stats.get(key, 0) + stats[key]
	
	set_stats(final_stats)

func get_stat(type: StatType) -> float:
	return _stats.get(type, 0)

func _on_hurt(before: Dictionary[StatType, float], after: Dictionary[StatType, float]):
	if after.has(StatType.HP) and before[StatType.HP] != after[StatType.]:
		on_hp_changed.emit(before[StatType.HP], after[StatType.HP])
	
@export var attack: float = 3.5

@export var speed: float = 70
@export var accel: float = 0
