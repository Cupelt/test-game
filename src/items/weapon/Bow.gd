extends Weapon
class_name Bow

var arrow_scene = preload("res://scene/projectile/arrow.tscn")


func attack(player: Player, direction: Vector2):
	var stats = player.stats
	ObjectPool.spawn_object(arrow_scene, {
		"position": player.global_position,
		
		"direction": direction,
		"attacker": player,
		"attack_info": AttackInfo.new(
			player, 
			attack_element, 
			stats.get_stat(EntityStats.StatType.ATTACK) * 3
		),
	})
	
	super(player, direction)
