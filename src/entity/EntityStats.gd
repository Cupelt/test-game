extends Node
class_name EntityStats

signal on_hp_changed(before: float, after: float)
signal on_stats_changed(before: Dictionary[StatType, float], after: Dictionary[StatType, float])

enum StatType {
	MAX_HP,
	ATTACK,
	ATTACK_SPEED,
	SPEED,
	ACCEL
}
@onready var body = $".."
@export var base_stats: Dictionary[StatType, float]
var _stats: Dictionary[StatType, float]

var _hp: float = 0
var hp: float:
	get:
		return _hp
	set(value):
		on_hp_changed.emit(_hp, value)
		Event.on_hp_changed.emit(body, _hp, value)
		# print(_hp - value)
		_hp = value

func _ready() -> void:
	reset()

func reset():
	_stats = base_stats.duplicate_deep()
	_hp = get_stat(StatType.MAX_HP)

func set_stats(stats: Dictionary[StatType, float]):
	on_stats_changed.emit(_stats.duplicate_deep(), stats.duplicate_deep())
	_stats.assign(stats)

func add_stats(stats: Dictionary[StatType, float]):
	var final_stats = _stats.duplicate_deep()
	for key in stats:
		final_stats[key] = final_stats.get(key, 0) + stats[key]
	
	set_stats(final_stats)

func get_stat(type: StatType) -> float:
	return _stats.get(type, 0)
