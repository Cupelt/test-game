extends ItemList

@export var stats: EntityStats
@export var allow_stats: Array[EntityStats.StatType]

func _ready() -> void:
	var index = 0
	for key in allow_stats:
		set_item_text(index, str(stats.get_stat(key)))
		index += 1
