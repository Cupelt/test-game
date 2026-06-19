extends Weapon
class_name BowShotgun

var arrow_scene = preload("res://scene/projectile/arrow.tscn")
@export_range(0, 180) var spread_angle: float = 10.0

func attack(player: Player, direction: Vector2) -> bool:
	var stats = player.stats
	
	var base_angle_rad = direction.angle()
	
	for i in range(10):
		var random_offset_deg = randf_range(-spread_angle / 2.0, spread_angle / 2.0)
		var random_offset_rad = deg_to_rad(random_offset_deg)
		
		var final_angle_rad = base_angle_rad + random_offset_rad
		var final_direction = Vector2.from_angle(final_angle_rad)
		
		ObjectPool.spawn_object(arrow_scene, {
			"position": player.global_position,
			
			"direction": final_direction,
			"attacker": player,
			"attack_info": AttackInfo.new(
				player, 
				stats.get_stat(EntityStats.StatType.ATTACK) * 3,
				weapon_type,
				attack_element,
			),
		})
	
	return super(player, direction)
