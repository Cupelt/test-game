@abstract extends ObjectPool
class_name Entity

@export var stats: EntityStats
@export var animTree: AnimationTree
var components: Array[Component]

var is_die: bool = false

func _ready() -> void:
	stats.hp_updated.connect(hurt)
	components.assign(get_children().filter(func (node): node is Entity))

func die():
	animTree["parameters/is_die/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE
	is_die = true

func hurt(before: float, after: float) -> void:
	animTree["parameters/is_hurt/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE
