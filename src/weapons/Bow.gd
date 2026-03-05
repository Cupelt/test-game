extends Node2D

@export var stats: EntityStats

@onready var range: Area2D = $FireRange

@export var arrow: PackedScene
@export var attack_rate: float = 1
var timer: float = 0;

func _process(delta: float) -> void:
	timer += delta
	
	var atk_rate = attack_rate / stats.attack_speed
	if timer > atk_rate:
		if fire_arrow():
			timer = 0

func fire_arrow() -> bool:
	var target = get_closest_target()
	if target == null:
		return false
	
	Entity.spawn_entity(arrow, {
		"target": target,
		"damage": stats.attack * 3,
		
		"position": global_position
	})
	
	return true

func get_closest_target() -> Entity:
	var targets = range.get_overlapping_bodies()
	if targets.is_empty():
		return null

	var closest_node: Node2D = null
	var min_dist: float = INF # 무한대로 초기화

	for target in targets:
		if not target.is_in_group("Enemy"):
			continue
		
		var dist = global_position.distance_squared_to(target.global_position)
		min_dist = dist
		closest_node = target

	return closest_node
