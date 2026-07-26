extends Timer
class_name DefaultSpawner

@export var player: Player
@export var nav_map: NavigationRegion2D
@export var entity_layer: Node2D

@export var enemy_scene: PackedScene
@export var min_spawn_radius: float = 300.0
@export var max_spawn_radius: float = 500.0

@export var max_enemy: int = 100

@export var spawn_interval_factor: float = 0.05
@export var max_spawn_interval: float = 1.0
@export_range(0.01, 1, 0.001) var min_spawn_interval: float = 0.1

@export var is_active = false

var minutes: float = 0
var spawn_accumulator: float = 0.0

static var total_enemy: int = 0

func _process(delta: float) -> void:
	if total_enemy >= max_enemy:
		return
	
	spawn_accumulator += delta
	minutes += delta / 60.0
	
	# 1 / 10 = 0.1초마다 실행됨
	var interval = max(min_spawn_interval, max_spawn_interval - (minutes * spawn_interval_factor))
	
	while spawn_accumulator >= interval:
		spawn_accumulator -= interval
		#var spawn_pos = get_valid_spawn_pos()
		#if spawn_pos == Vector2.INF:
			#continue
			
		var random_direction = Vector2.RIGHT.rotated(randf_range(0, TAU))
		var dist = randf_range(min_spawn_radius, max_spawn_radius)
		var spawn_pos = player.global_position + (random_direction * dist)
		
		ObjectPool.spawn_object(enemy_scene, {
			"position": spawn_pos, 
		})

func get_valid_spawn_pos() -> Vector2:
	for i in range(5): # 최대 5번 시도
		var random_direction = Vector2.RIGHT.rotated(randf_range(0, TAU))
		var dist = randf_range(min_spawn_radius, max_spawn_radius)
		var target_pos = player.global_position + (random_direction * dist)
		
		var safe_pos = NavigationServer2D.map_get_closest_point(nav_map.get_navigation_map(), target_pos)
		
		var actual_dist = safe_pos.distance_to(player.global_position)
		if actual_dist < min_spawn_radius or actual_dist > max_spawn_radius + 200:
			continue
			
		if is_path_efficient(safe_pos, player.global_position):
			return safe_pos
		
	return Vector2.INF
	
func is_path_efficient(start_pos: Vector2, target_pos: Vector2) -> bool:
	var path = NavigationServer2D.map_get_path(nav_map.get_navigation_map(), start_pos, target_pos, true)
	var path_length = 0.0
	for i in range(path.size() - 1):
		path_length += path[i].distance_to(path[i+1])
		
	# 실제 경로가 직선 거리의 2배 이상이면 부적합한 위치로 판단
	return path_length < start_pos.distance_to(target_pos) * 2.0
