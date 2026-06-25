extends RefCounted
class_name ElementData

var gauge: float
var decay_rate: float

func _init(_gauge: float, _duration: float):
	gauge = _gauge
	decay_rate = _gauge / _duration 

func update(delta: float) -> bool:
	gauge -= decay_rate * delta
	return gauge <= 0.0
