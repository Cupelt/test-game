extends CharacterBody2D
@onready var animated_sprite_2d = $AnimatedSprite2D

var SPEED = 70;

# Called when the node enters the scene tree for the first time. 2.15
func _ready() -> void:
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	move_and_slide()
	MapManager.Instance.currentPlayerPos = MapManager.Instance.global_pos_to_room_pos(global_position)
	
#func _input(event: InputEvent) -> void:
	## Debug
	#if (Input.is_action_pressed("Debug")):
		#SPEED -= 10
		#print(SPEED)
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var direction: Vector2 = Input.get_vector("Left", "Right", "Up", "Down") \
		.normalized()
	
	#region Player Movement
	velocity = direction * SPEED
	#endregion
	
	#region Player Animation
	var beforeAnim = String(animated_sprite_2d.animation).split("_")
	 
	if (direction.is_zero_approx()):
		beforeAnim[0] = "Idle"
		# animated_sprite_2d.speed_scale = 1
	else:
		beforeAnim[0] = "Walk"
	
	if (direction.x != 0):
		beforeAnim[1] = "Left"
		if direction.x < 0:
			animated_sprite_2d.flip_h = true
		elif direction.x > 0:
			animated_sprite_2d.flip_h = false
	
	if (direction.y < 0):
		beforeAnim[1] = "Up"
	elif (direction.y > 0):
		beforeAnim[1] = "Down"
	
	animated_sprite_2d.play("_".join(beforeAnim))
	#endregion
