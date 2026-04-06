extends TextureProgressBar

@export var stats: EntityStats

func _ready() -> void:
	stats.on_hp_changed.connect(update)
	
func init() -> void:
	self.visible = false

func update(before: float, after: float):
	visible = true
	value = after / stats.get_stat(EntityStats.StatType.MAX_HP)
