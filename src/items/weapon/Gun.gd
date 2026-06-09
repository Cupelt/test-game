extends Weapon
class_name HitScanGun

@export var max_range = 999
var muzzle_flash: Node2D

func attack(player: Player, direction: Vector2):
	var stats = player.stats
	
	var space_state = player.get_world_2d().direct_space_state
	
	var start_pos = player.global_position
	var end_pos = start_pos + (direction * max_range)
	
	var query = PhysicsRayQueryParameters2D.create(start_pos, end_pos)
	query.exclude = [player.get_rid()]
	
	var result = space_state.intersect_ray(query)
	if result:
		var hit_collider = result.collider
		var hit_position = result.position
		
		if not hit_collider.is_in_group("Enemy"):
			return
		
		if hit_collider.is_die:
			return
		
		if hit_collider.stats != null:
			var damage = player.stats.get_stat(EntityStats.StatType.ATTACK) * 10
			hit_collider.stats.give_damage(AttackInfo.new(
				player, 
				Reaction.AttackType.VOID, 
				damage
			))
		
		print("히트스캔 적중!: ", hit_collider.name, " 위치: ", hit_position)
	
	super(player, direction)
