extends TextureProgressBar
class_name HpViewComponent

@export var stats: EntityStats
@export var catch_delay = 0.2
@export var catch_duration: float = 0.4
@export var max_catch_interval: float = 1

@onready var catch_bar = $HpCatchPrograss

var catch_tween: Tween
var total_interval: float = 0

func _ready() -> void:
	init()
	
func init() -> void:
	self.visible = false
	# _connect_stats_signals()

func _connect_stats_signals():
	if stats and not stats.on_attacked.is_connected(update):
		stats.on_attacked.connect(update)
	
func update(data: AttackResult) -> void:
	var max_hp = stats.get_stat(EntityStats.StatType.MAX_HP)
	var new_value = stats.get_stat(EntityStats.StatType.HP) - data.damage
	
	visible = max_hp > new_value
	var target_ratio = new_value / max_hp
	value = target_ratio
	
	if catch_tween and catch_tween.is_valid():
		total_interval += catch_tween.get_total_elapsed_time()
		catch_tween.kill()
		
	catch_tween = get_tree().create_tween()
	if total_interval <= max_catch_interval:
		catch_tween.tween_interval(catch_delay)
	
	catch_tween.tween_property(catch_bar, "value", target_ratio, catch_duration)\
		.set_trans(Tween.TRANS_SINE) \
		.set_ease(Tween.EASE_OUT)
	
	catch_tween.tween_callback(func (): total_interval = 0)
	
	
