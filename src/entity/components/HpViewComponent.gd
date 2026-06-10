extends TextureProgressBar

@export var stats: EntityStats
@onready var late_bar = $HpPrograssLate

func _ready() -> void:
	stats.on_attacked.connect(update)
	
func init() -> void:
	self.visible = false

func _process(delta: float) -> void:
	late_bar.value = move_toward(
		late_bar.value,
		value,
		40.0 * delta
	)
	
func update(data: AttackInfo) -> void:
	var max_hp = stats.get_stat(EntityStats.StatType.MAX_HP)
	var new_value = stats.get_stat(EntityStats.StatType.HP) - data.damage
	
	visible = max_hp > new_value
	value = new_value / max_hp
