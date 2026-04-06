extends Entity
class_name Slime

var time: float = 0.0

func _ready() -> void:
	stats.on_hp_changed.connect(on_hurt)

func init(data: Dictionary) -> void:
	self.position = data["position"]
	time = 0;
	stats.reset()
	$HpViewComponent.init()
	$ChasingComponent.is_chasing = true
	
	reset()
	pass

func _process(delta: float) -> void:
	pass
	#time += delta
	#
	#if time > 5:
		#destroy_object()

func on_hurt(before: float, after: float) -> void:
	if after > 0:
		return
	
	$ChasingComponent.is_chasing = false
	die()
