extends CharacterBody3D

const SPEED = 1.0
const JUMP_VELOCITY = 2.5

@onready var sprite: AnimatedSprite3D = $AnimatedSprite3D
@onready var camera_controller: Node3D = $camera_controller

var hit_wall = false
var wall_normal = Vector3.ZERO

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = 0
		velocity.z = 0

	move_and_slide()

	# ดัน player กลับเมื่อชนขอบ
	if hit_wall:
		global_position += wall_normal * 0.05

	# Flip the sprite depending on direction (left/right)
	if abs(velocity.x) > 0.1:
		sprite.flip_h = velocity.x < 0

	# Play animation
	if direction:
		sprite.play("walk")
	else:
		sprite.play("idle")

	# Handle camera
	var camera_position = $camera_controller.position
	var camera_speed = 5.0
	var target_x = 0.0
	var target_y = 0.3
	var target_z = 0.7

	camera_position.x = lerp(camera_position.x, target_x, camera_speed * delta)
	camera_position.y = lerp(camera_position.y, target_y, camera_speed * delta)
	camera_position.z = lerp(camera_position.z, target_z, camera_speed * delta)

	$camera_controller.position = camera_position

func _on_boundary_wall_body_entered(body: Node3D) -> void:
	if body == self:
		hit_wall = true
		# ดันเข้าหา center (Vector3.ZERO) แทน
		wall_normal = (Vector3.ZERO - global_position).normalized()
		wall_normal.y = 0

func _on_boundary_wall_body_exited(body: Node3D) -> void:
	if body == self:
		hit_wall = false
		wall_normal = Vector3.ZERO
