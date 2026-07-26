extends Entity
class_name Player

# @onready var animation_tree = $Sprite2D/AnimationTree
# @onready var stats: EntityStats = $StatsContainer

var map_pos: Vector2i = Vector2i.MAX

var gold: int = 0

func init(data: Dictionary) -> void:
	reset()
	# 플레이어 스폰 시 초기화 로직이 필요하다면 여기에 작성
	if data.has("position"):
		global_position = data["position"]

# Called when the node enters the scene tree for the first time. 2.15
func _ready() -> void:
	GlobalContainer.player = self
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	move_and_slide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var direction: Vector2 = Input.get_vector("Left", "Right", "Up", "Down") \
		.normalized()
	
	#region Player Movement
	# TODO 넉백추가
	velocity = velocity.move_toward(
		direction * stats.get_stat(EntityStats.StatType.SPEED), 
		delta * 2500
	)
	# velocity = direction * SPEED
	#endregion
	
	#region Player Animation
	 
	animTree["parameters/is_walk/blend_amount"] = float(!direction.is_zero_approx())
	if (direction.x != 0):
		animTree["parameters/is_flip/blend_amount"] = float(direction.x < 0)
	#endregion
