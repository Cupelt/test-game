extends Entity

var direction: Vector2

var damage: float
@export_range(1, 10, 0.1) var life_time: float = 5;
var timer: float = 0;

@export var area: Area2D

func _ready() -> void:
	area.body_entered.connect(hit)

func init(data: Dictionary) -> void:
	timer = 0
	global_position = data["position"]
	
	direction = data["direction"]
	rotation = direction.angle()
	
	damage = data["damage"]
	pass

func _process(delta: float) -> void:
	timer += delta
	global_position += direction * stats.get_stat(EntityStats.StatType.SPEED)
	
	if (timer > life_time):
		call_deferred("destroy_object")

func hit(body: Entity):
	if not body.is_in_group("Enemy"):
		return
	
	if body.is_die:
		return
	
	if body.stats != null and body.stats :
		body.stats.add_stats(EntityStats.StatType.HP, -damage)
		
	call_deferred("destroy_object")
