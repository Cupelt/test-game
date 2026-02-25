extends Node2D

# Called when the node enters the scene tree for the first time.
@export var collision: CollisionShape2D
@onready var separation_area = $Area2D

@export var push_force: float = 20.0  # 밀어내는 힘의 강도

func _ready() -> void:
	$Area2D/CollisionShape2D.shape = collision.shape

#func _physics_process(delta):
	#var target = GlobalContainer.player
	#if not target: return
	#
	#var separation = Vector2.ZERO
	#var neighbors = separation_area.get_overlapping_areas()
	#
	#for area in neighbors:
		## 부모가 자기 자신인 경우는 제외 (이미 Collision Layer 설정으로 걸러지지만 안전장치)
		#if area == self: continue
		#
		## 상대방으로부터 멀어지는 방향 계산
		#var diff = global_position - area.global_position
		#if diff.length() > 0:
			## 거리가 가까울수록 더 강하게 밀어냄 (역자승 또는 반비례)
			#separation += diff.normalized() / diff.length()
	#$"..".velocity += ($"..".velocity * separation)
	#$"..".move_and_slide()
