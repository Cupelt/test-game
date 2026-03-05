extends TextureProgressBar

@export var stats: EntityStats

func _ready() -> void:
	stats.hp_updated.connect(update)

func update(before: float, after: float):
	visible = true
	value = after / stats.max_hp
