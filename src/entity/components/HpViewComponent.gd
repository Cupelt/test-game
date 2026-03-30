extends TextureProgressBar

@export var stats: EntityStats

func _ready() -> void:
	stats.hp_updated.connect(update)
	
func init() -> void:
	self.visible = false

func update(before: float, after: float):
	visible = true
	value = after / stats.max_hp
