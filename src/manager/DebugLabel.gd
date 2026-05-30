extends RichTextLabel

@export var data: WeaponController
@onready var origin = text

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var current_data: Array = [
		data.current_weapon.name,
		data.current_weapon.attack_rate,
		data.current_weapon.attack_cooldown,
		data.current_weapon.max_ammo,
		data.current_weapon.current_ammo,
		data.current_weapon.reload_delay,
		data.current_weapon.reload_cooldown,
	]
	
	text = origin % current_data
	pass
	
