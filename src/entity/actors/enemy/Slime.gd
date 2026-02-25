extends Entity
class_name Slime

var time: float = 0.0

func init(data: Dictionary) -> void:
	self.position = data["position"]
	time = 0;
	pass

func _process(delta: float) -> void:
	time += delta
	
	if time > 5:
		destroy_entity()
