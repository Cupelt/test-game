extends Node2D
class_name WeaponController

@export var player: Player

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
		if weapons[i]:
			var target = weapons[i]
			target.current_ammo = target.max_ammo
			
			if i == _current_weapon_index:
				target.set_equip(true)
	pass # Replace with function body.

func _input(event: InputEvent) -> void:
	if !(event is InputEventKey) or not event.pressed:
		return
	
	if Input.is_action_pressed("Reload"):
		current_weapon.reload()
		
	var hotbar_range = range(4)
	for i in hotbar_range:
		if Input.is_action_pressed("Hotbar_" + str(i)):
			# TODO: weapon change event (못바꿀때도 포함.)
			if not weapons.has(i) or weapons[i] == null:
				print("cannot equip the weapon in slot %d" % i)
				continue
			
			switch_weapon(i)
			break

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# attack
	if Input.is_action_pressed("Attack") and current_weapon.can_attack():
		var direction = get_global_mouse_position() - player.global_position
		current_weapon.attack(player, direction.normalized())
	
	# cooldowns
	for i in weapons:
		var target = weapons[i]
		if not target: continue
		
		# reload_cooldown
		target.update_cooldowns(delta)
	
	pass

func switch_weapon(index: int) -> void:
	if not weapons.has(index) or weapons[index] == null:
		print("%d 슬롯에는 무기가 없습니다." % index)
		return
		
	if _current_weapon_index == index:
		return
	
	current_weapon.set_equip(false)
	
	_current_weapon_index = index
	current_weapon.set_equip(true)
