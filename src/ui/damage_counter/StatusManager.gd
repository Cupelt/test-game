extends Node2D
class_name StatusManager

@export var stats: EntityStats
@onready var hp_prograss = $HpPrograssComponent

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hp_prograss.stats = stats
	pass # Replace with function body.

func update():
	pass
	
