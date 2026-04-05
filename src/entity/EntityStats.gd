extends Node
class_name EntityStats

signal hp_updated(before: float, after: float)

var hp: float = max_hp :
	set(after_hp):
		hp_updated.emit(hp, after_hp)
		hp = after_hp

@export var max_hp: float = 100
@export var attack: float = 3.5

@export var speed: float = 70
@export var accel: float = 0
