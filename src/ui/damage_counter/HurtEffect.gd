extends Area2D

@onready var particle = $HitParticle

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var is_hurt = false
	
	for area in get_overlapping_areas():
		var body = area.get_parent()
		
		if body is NearAttackComponent:
			is_hurt = true
			break
	
	particle.emitting = is_hurt
	pass
