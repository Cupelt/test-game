extends Entity
class_name Slime

var time: float = 0.0

func init(data: Dictionary) -> void:
	self.position = data["position"]
	time = 0;
	stats.hp = stats.max_hp
	$HpViewComponent.init()
	$ChasingComponent.is_chasing = true
	pass

func _process(delta: float) -> void:
	pass
	#time += delta
	#
	#if time > 5:
		#destroy_object()

func _on_stats_container_hp_updated(before: float, after: float) -> void:
	if after > 0:
		return
	
	$ChasingComponent.is_chasing = false
	die()
