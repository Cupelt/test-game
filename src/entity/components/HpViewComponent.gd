extends TextureProgressBar

@export var stats: EntityStats

func _ready() -> void:
	stats.on_stats_changed.connect(update)
	
func init() -> void:
	self.visible = false
	
func update(type: EntityStats.StatType, old_value: float, new_value: float) -> void:
	if type != EntityStats.StatType.HP:
		return
	
	visible = true
	value = new_value / stats.get_stat(EntityStats.StatType.MAX_HP)
