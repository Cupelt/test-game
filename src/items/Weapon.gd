@abstract extends Item
class_name Weapon

@export_category("General Setting")
@export var ingame_sprite: Texture2D
@export var attack_element: AttackType:
	set(value):
		if !value.is_weapon:
			attack_element = value
@export var weapon_type: AttackType:
	set(value):
		if value.is_weapon:
			weapon_type = value

@export var is_disable = false
var _is_equipped: bool = false

@export_category("Ammo Setting")
@export var is_infinity_ammo = false
@export var max_ammo: int
@export var reload_delay: float
var current_ammo: int
var is_reloading: bool = false

@export_category("Attack Setting")
@export var attack_rate: float
var attack_cooldown: float = 0.0
var reload_cooldown: float = 0.0

func can_attack() -> bool:
	if is_disable: return false
	if attack_cooldown > 0: return false
	if reload_cooldown > 0: return false
	return true

func attack(player: Player, direction: Vector2) -> bool:
	if not is_infinity_ammo:
		current_ammo -= 1
		# ammo_changed.emit(current_ammo, max_ammo)
	
	attack_cooldown = attack_rate
	if not is_infinity_ammo and current_ammo <= 0:
		reload()
	
	return true
	
func set_equip(is_equip: bool):
	_is_equipped = is_equip
	if not _is_equipped:
		if not is_infinity_ammo and current_ammo < max_ammo:
			reload()
	elif is_reloading:
		is_reloading = false
		reload_cooldown = 0.0
		

func reload():
	if is_infinity_ammo or is_reloading or current_ammo >= max_ammo:
		return
	
	reload_cooldown = reload_delay
	is_reloading = true
	pass

func update_cooldowns(delta: float):
	if attack_cooldown > 0:
		attack_cooldown -= delta
	
	# reload
	if is_reloading:
		reload_cooldown -= delta
		if reload_cooldown <= 0:
			current_ammo = max_ammo
			is_reloading = false
			# reload_finished.emit()
	
	
