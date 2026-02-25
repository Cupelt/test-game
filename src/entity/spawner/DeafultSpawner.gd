extends Timer

@export var player: Player
@export var nav_map: NavigationRegion2D
@export var entity_layer: Node2D

@export var enemy_scene: PackedScene
@export var spawn_radius: float = 700.0

@export var spawn_interval_factor: float = 0.05
@export var max_spawn_interval: float = 1.0
@export_range(0.01, 1, 0.001) var min_spawn_interval: float = 0.1

var minutes: float = 0
var spawn_accumulator: float = 0.0

func _process(delta: float) -> void:
	spawn_accumulator += delta
	minutes += delta / 60.0
	
	# 1 / 10 = 0.1초마다 실행됨
	var interval = max(min_spawn_interval, max_spawn_interval - (minutes * spawn_interval_factor))
	
	while spawn_accumulator >= interval:
		var random_direction = Vector2.RIGHT.rotated(randf_range(0, TAU))
		var spawn_pos = player.global_position + (random_direction * spawn_radius)
		spawn_pos = get_safe_spawn_pos(spawn_pos)
		
		Entity.spawn_entity(enemy_scene, entity_layer, {
			"position": spawn_pos, 
		})
		
		spawn_accumulator -= interval


func get_safe_spawn_pos(target_pos: Vector2) -> Vector2:
	var safe_pos = NavigationServer2D.map_get_closest_point(nav_map.get_navigation_map(), target_pos)
	return safe_pos
