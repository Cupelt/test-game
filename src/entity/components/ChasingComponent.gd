extends Node2D

var target: Node2D
@export var stats: EntityStats

@onready var parent = $".."
@onready var nav_timer = $NavUpdateTimer

@onready var nav_agent_node: NavigationAgent2D = $NavigationAgent2D
var is_chasing = true

# Called when the node enters the scene tree for the first time.	
func _ready():
	# 타이머 연결 (타겟 위치 갱신 전용)
	nav_timer.timeout.connect(_update_path)
	target = GlobalContainer.player

func _update_path():
	if is_chasing and target:
		nav_agent_node.target_position = target.global_position

func _physics_process(delta: float) -> void:
	# 1. 상태 체크 (가장 가벼운 조건부터)
	if not is_chasing or target == null:
		return

	# 2. 다음 경로 확인
	if nav_agent_node.is_navigation_finished():
		return

	var next_position = nav_agent_node.get_next_path_position()
	
	# 3. 이동 계산
	# global_position 대신 parent의 위치를 사용해야 정확할 수 있습니다.
	var direction = (next_position - parent.global_position).normalized()
	
	parent.velocity = parent.velocity.move_toward(
		direction * stats.get_stat(EntityStats.StatType.SPEED), 
		stats.get_stat(EntityStats.StatType.ACCEL) * delta
	)
	
	parent.move_and_slide()
