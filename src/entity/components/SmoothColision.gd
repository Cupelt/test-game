extends Node2D

@export var collision: CollisionShape2D
@onready var separation_area = $Area2D
@onready var parent: CharacterBody2D = $".."

@export var push_force: float = 200.0
@export var friction: float = 0.75

func _ready() -> void:
	$Area2D/CollisionShape2D.shape = collision.shape

func _physics_process(delta):
	var max_speed = parent.velocity.length()
	var separation_vector = calculate_separation_vector()
	var combined_velocity = parent.velocity + (separation_vector * push_force)
	parent.velocity = parent.velocity.lerp(combined_velocity, 1 - friction)

func calculate_separation_vector() -> Vector2:
	var push_vector = Vector2.ZERO
	var overlapping_areas = separation_area.get_overlapping_areas()
	
	# 충돌 영역의 반지름을 가져옴 (거리 계산 기준용)
	var radius = 32.0
	if collision.shape is CircleShape2D:
		radius = collision.shape.radius
	
	for area in overlapping_areas:
		if area.owner != parent:
			var dir_away = global_position - area.global_position
			var distance = dir_away.length()
			
			# 반지름 합보다 가까울 때만 밀어내기
			if distance > 0 and distance < radius * 2:
				# [개선] 거리가 가까울수록 1에 가깝고, 멀어질수록 0에 수렴하는 선형 공식
				# 분모가 0이 되어 급격하게 튕기는 현상을 막아줍니다.
				var strength = 1.0 - (distance / (radius * 2))
				push_vector += dir_away.normalized() * strength
				
	return push_vector
