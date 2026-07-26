extends RefCounted
class_name AttackData

var damage: float = 0
var element_type: ElementType = null
var element_duration: float = 10

var weapon_type: WeaponType

func apply_attack(target: Entity) -> void:
	if target.is_die:
		return
	
	var result: AttackResult = AttackResult.new(self, target)
	
	var target_stats: EntityStats = target.stats
	
	var target_elements = target.stats.attached_elements
	var trigger_type = element_type
	
	for source_type in target_elements.keys():
		var reaction: Reaction = ReactionManager.get_reaction(source_type, trigger_type)
		if reaction:
			reaction.apply_effect(result)
			result._reactions.append(reaction)
			
			target_stats.on_reaction_triggered.emit(
				result,
				source_type, element_type,
				reaction
			)
			
			target_stats.remove_attatch_element(source_type)
	
	if not result.is_reacted:
		target_stats.add_attatch_element(trigger_type, element_duration)
	
	target_stats.on_attacked.emit(result)
	Event.on_attacked.emit(result)
	
	target.stats.add_stats(EntityStats.StatType.HP, -result.damage)

class Builder:
	extends RefCounted
	
	var _instance: AttackData = AttackData.new()
	
	func refrence_weapon(weapon: Weapon) -> Builder:
		_instance.element_type = weapon.attack_element
		_instance.element_duration = weapon.element_duration
		
		_instance.weapon_type = weapon.weapon_type
		return self
	
	func set_attacker(attacker: Node) -> Builder:
		_instance.attacker = attacker
		return self
		
	func set_damage(damage: float) -> Builder:
		_instance.damage = damage
		return self
	
	func set_damage_by_stats(stats: EntityStats, type: EntityStats.StatType, factor: float) -> Builder:
		_instance.damage = stats.get_stat(type) * factor
		return self
	
	func set_weapon(type: WeaponType) -> Builder:
		_instance.weapon_type = type
		return self
	
	func set_element(type: ElementType, duration: float) -> Builder:
		_instance.element_type = type
		_instance.element_duration = duration
		return self
	
	func build() -> AttackData:
		assert(_instance.weapon_type != null, "AttackData: 'weapon_type'은 null일 수 없습니다.")
		return _instance
	
	
