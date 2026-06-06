@abstract extends ObjectPool
class_name Entity

@export var stats: EntityStats
@export var animTree: AnimationTree
var components: Array[Component]

var is_die: bool = false

func _ready() -> void:
	stats.on_stats_changed.connect(hurt)
	components.assign(get_children().filter(func (node): node is Entity))
	
func reset() -> void:
	is_die = false

func die():
	animTree["parameters/is_die/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE
	is_die = true

func hurt(type: EntityStats.StatType, old_value: float, new_value: float) -> void:
	if type != EntityStats.StatType.HP:
		return
	animTree["parameters/is_hurt/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE
