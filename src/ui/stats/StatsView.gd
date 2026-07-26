extends RichTextLabel

@export var player: Player
@onready var stats: EntityStats = player.stats
@export var allow_stats: Array[EntityStats.StatType]

@onready var origin = text

func _process(delta: float) -> void:
	var context = [player.gold]
	
	for key in allow_stats:
		context.append(stats.get_stat(key))
	
	text = origin % context
