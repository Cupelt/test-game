extends Entity

var direction: Vector2
@onready var sprite: Sprite2D = $Sprite2D

var attack_data: AttackData
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
	
	attack_data = data["attack_data"]
	pass

func _process(delta: float) -> void:
	timer += delta
	global_position += direction * stats.get_stat(EntityStats.StatType.SPEED)
	
	if (timer > life_time):
		ObjectPool.safe_destroy_object(self)

func hit(body: Entity):
	if not body.is_in_group("Enemy"):
		return
		
	attack_data.apply_attack(body)
	ObjectPool.safe_destroy_object(self)
