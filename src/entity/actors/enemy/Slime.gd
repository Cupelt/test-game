extends Entity
class_name Slime

var time: float = 0.0

func _ready() -> void:
	stats.on_attacked.connect(on_die)

func init(data: Dictionary) -> void:
	self.position = data["position"]
	time = 0;
	stats.reset()
	$StatusComponent.init()
	$ChasingComponent.is_chasing = true
	
	reset()
	pass

func _process(delta: float) -> void:
	pass
	#time += delta
	#
	#if time > 5:
		#destroy_object()

func on_die(data: AttackResult) -> void:
	if stats.get_stat(EntityStats.StatType.HP) - data.damage > 0:
		return
	
	$ChasingComponent.is_chasing = false
	die()
