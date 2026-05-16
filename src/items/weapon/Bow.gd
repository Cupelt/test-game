extends Node2D

@export var stats: EntityStats

@onready var range: Area2D = $FireRange

@export var arrow: PackedScene
@export var attack_rate: float = 1
var timer: float = 0;

var target_list: Array[Node2D]

func _ready() -> void:
	range.body_entered.connect(target_enterd)
	range.body_exited.connect(target_exited)

func target_enterd(body: Node2D):
	target_list.append(body)
	
func target_exited(body: Node2D):
	target_list.erase(body)

func _physics_process(delta: float) -> void:
	timer += delta
	
	var atk_rate = attack_rate / stats.get_stat(EntityStats.StatType.ATTACK_SPEED)
	if timer > atk_rate:
		# 발사를 해야 시간 초기화
		if fire_arrow():
			timer = 0

func fire_arrow() -> bool:
	var target = get_closest_target()
	if target == null:
		return false
	
	ObjectPool.spawn_object(arrow, {
		"target": target,
		"damage": stats.get_stat(EntityStats.StatType.ATTACK) * 3 * MathHelper.randomize_damage_factor(),
		
		"position": global_position
	})
	
	return true

func get_closest_target() -> Entity:
	var closest_node: Node2D = null
	var min_dist: float = INF # 무한대로 초기화

	for target in target_list:
		if not target.is_in_group("Enemy") or target.is_die or not target.is_enabled:
			continue
			
		if (!range.overlaps_body(target)):
			continue
		
		var dist = global_position.distance_to(target.global_position)
		if (min_dist > dist):
			min_dist = dist
			closest_node = target

	return closest_node
