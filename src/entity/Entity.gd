@abstract extends CharacterBody2D
class_name Entity

@export var stats: EntityStats
@export var animTree: AnimationTree
var components: Array[Component]

var is_die: bool = false

func _ready() -> void:
	stats.on_attacked.connect(hurt)
	components.assign(get_children().filter(func (node): node is Entity))
	
func reset() -> void:
	is_die = false

func die():
	animTree["parameters/is_die/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE
	is_die = true

func return_object():
	ObjectPool.destroy_object(self)

func hurt(data: AttackResult) -> void:
	animTree["parameters/is_hurt/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE
