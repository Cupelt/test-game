extends Node2D
class_name WeaponController

var _current_weapon_index: int = 0
var current_weapon: Weapon:
	get:
		return weapons[_current_weapon_index]
	set(value):
		_current_weapon_index = -1
		weapons[-1] = value

@export var weapons: Dictionary[int, Weapon]

func _ready() -> void:
	for i in weapons:
		var target = weapons[i]
		target.current_ammo = target.max_ammo
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# attack
	if Input.is_action_pressed("Attack") \
			and current_weapon.attack_cooldown <= 0 \
			and (current_weapon.is_infinity_ammo or current_weapon.current_ammo > 0):
		
		current_weapon.attack()
		
		if (not current_weapon.is_infinity_ammo):
			current_weapon.current_ammo -= 1
		
		if (current_weapon.current_ammo <= 0 \
				and not current_weapon.is_infinity_ammo):
			current_weapon.reload_cooldown = current_weapon.reload_delay
		else:
			current_weapon.attack_cooldown = current_weapon.attack_rate
		
	
	# cooldowns
	for i in weapons:
		var target = weapons[i]
		if not target: continue
		
		# reload_cooldown
		if target.reload_cooldown > 0:
			target.reload_cooldown -= delta
			if target.reload_cooldown <= 0:
				target.current_ammo = target.max_ammo
		
		# attack cooldown
		if (target.attack_cooldown > 0):
			target.attack_cooldown -= delta
	
	pass
