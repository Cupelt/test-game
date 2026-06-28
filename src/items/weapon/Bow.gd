extends Weapon
class_name Bow

var arrow_scene = preload("res://scene/projectile/arrow.tscn")


func attack(player: Player, direction: Vector2) -> bool:
	var stats = player.stats
	ObjectPool.spawn_object(arrow_scene, {
		"position": player.global_position,
		
		"direction": direction,
		"attacker": player,
		"attack_data": AttackData.Builder.new()\
			.refrence_weapon(self)\
			.set_damage_by_stats(stats, EntityStats.StatType.ATTACK, 3)\
			.build(),
	})
	
	return super(player, direction)
