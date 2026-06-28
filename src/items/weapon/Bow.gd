extends Weapon
class_name Bow

var arrow_scene = preload("res://scene/projectile/arrow.tscn")


func attack(player: Player, direction: Vector2) -> bool:
	var stats = player.stats
	ObjectPool.spawn_object(arrow_scene, {
		"position": player.global_position,
		
		"direction": direction,
		"attacker": player,
		"attack_data": AttackData.new(
			player, 
			stats.get_stat(EntityStats.StatType.ATTACK) * 3,
			weapon_type,
			attack_element,
		),
	})
	
	return super(player, direction)
