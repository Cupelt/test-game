@abstract extends Item
class_name Weapon

@export var ingame_sprite: Texture2D

@export var is_infinity_ammo = false
@export var max_ammo: int
@export var reload_delay: float
var current_ammo: int
var reload_cooldown: float

@export var attack_rate: float
var attack_cooldown: float

func attack():
	pass
