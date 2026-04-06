extends ItemList

@export var stats: EntityStats

func _ready() -> void:
	
	for key in EntityStats.StatType.values():
		set_item_text(key, str(stats.get_stat(key)))
	
	
	
