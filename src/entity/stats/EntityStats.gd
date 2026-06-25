extends Node
class_name EntityStats

signal on_stats_changed(type: StatType, old_value: float, new_value: float)
signal on_attacked(data: AttackInfo)
signal on_reaction_triggered(source: AttackType, trigger: AttackType, reaction: Reaction)
signal on_status_changed(old_status: AttackType, new_status: AttackType)

enum StatType {
	MAX_HP, HP, HP_GENERATION,
	ATTACK, ATTACK_SPEED,
	SPEED
}

@export var parent: Entity
@export var base_stats: Dictionary[StatType, float]
var _stats: Dictionary[StatType, float]

#var attached_elements: Dictionary[ElementType, Node]
var attached_elements: Dictionary[ElementType, ElementData]

func _ready() -> void:
	reset()

func reset():
	_stats = base_stats.duplicate_deep()
	if _stats.has(StatType.MAX_HP) and (not _stats.has(StatType.HP) or base_stats[StatType.HP] <= 0):
		_stats[StatType.HP] = _stats[StatType.MAX_HP]
		
func _process(delta: float):
	for key in attached_elements.keys().duplicate_deep():
		if attached_elements[key].update(delta):
			attached_elements.erase(key)

func give_damage(data: AttackInfo):
	if parent.is_die:
		return
	
	data.target = parent
	
	var reaction_list: Array[Reaction]
	reaction_list.append_array(apply_reaction(data, data.element_type, data.element_gauge)) # Element Rection
	reaction_list.append_array(apply_reaction(data, data.weapon_type, 0)) # Weapon Reaction
	
	#if before_status != status_effect:
		#on_status_changed.emit(before_status, status_effect)
	
	on_attacked.emit(data)
	Event.on_attacked.emit(data)
	
	add_stats(EntityStats.StatType.HP, -data.damage)

func apply_reaction(data: AttackInfo, type: AttackType, gauge: float) -> Array[Reaction]:
	var reactions: Array[Reaction]
	var trigger_type = data.element_type
	var trigger_gauge = data.element_gauge
	
	for source_type in attached_elements.keys():
		
		var reaction: Reaction = ReactionManager.get_reaction(source_type, type)
		if reaction:
			reaction.apply_effect(data)
			reactions.append(reaction)
			
			var consume_rate = reaction.get_consume_rate(source_type, trigger_type)
			if attached_elements[source_type].gauge > (trigger_gauge * consume_rate):
				# 기존 원소가 더 강해서 남는 경우: 들어온 원소는 소멸, 기존 원소 차감
				attached_elements[source_type].gauge -= trigger_gauge * consume_rate
				trigger_gauge = 0.0
				break
			else:
				# 들어온 원소가 더 강해서 기존 원소를 먹어치운 경우
				trigger_gauge -= attached_elements[source_type].gauge / consume_rate
				attached_elements[source_type].gauge = 0.0 # 이 원소는 다음 프레임이나 루프 후 제거됨
			
			on_reaction_triggered.emit(trigger_type, type, reaction)
	
	if not trigger_type is WeaponType and trigger_gauge > 0.0:
		_add_or_refresh_element(trigger_type, trigger_gauge, data.element_duration)
	
	return reactions
	
func _add_or_refresh_element(type: ElementType, gauge: float, duration: float):
	if attached_elements.has(type):
		attached_elements[type].gauge = max(attached_elements[type].gauge, gauge)
		return
	
	var new_element = ElementData.new(gauge, duration)
	new_element.gauge = gauge
	attached_elements[type] = new_element

func set_stats(type: StatType, value: float):
	var old_value = get_stat(type)
	_stats[type] = value
	on_stats_changed.emit(type, old_value, value)
	Event.on_stats_changed.emit(parent, type, old_value, value)

func add_stats(type: StatType, value: float):
	set_stats(type, get_stat(type) + value)
	
func set_stats_list(stats: Dictionary[StatType, float]):
	var old_stats = _stats.duplicate_deep()
	_stats.assign(stats)
	
	for k in stats:
		on_stats_changed.emit(k, old_stats[k], stats[k])
		Event.on_stats_changed.emit(parent, k, old_stats[k], stats[k])
	
func add_stats_list(stats: Dictionary[StatType, float]):
	var final_stats = _stats.duplicate_deep()
	for key in stats:
		final_stats[key] = final_stats.get(key, 0) + stats[key]
	
	set_stats_list(final_stats)

func get_stat(type: StatType) -> float:
	return _stats.get(type, 0)
