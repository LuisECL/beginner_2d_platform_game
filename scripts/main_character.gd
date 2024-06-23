extends CharacterBody2D

const SPEED = 400.0
const JUMP_VELOCITY = -600.0
const WALL_JUMP_VELOCITY = JUMP_VELOCITY * 1.5
const WALL_JUMP_PUSHBACK = 1000
const GRAVITY = 1600
const FALL_GRAVITY = 2400
var was_airbourne = false
var was_on_wall = false
var block_wall_slide = false
var allow_jump = true
@onready var animated_sprite = $AnimatedSprite2D
@onready var ray_cast_left = $RayCastLeft
@onready var ray_cast_right = $RayCastRight
@onready var coyote_timer = $CoyoteTimer

# Auxiliary functions
func handle_animation(direction: int):
	# Flip character
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true

	# Play animations
	if not is_on_floor():
		if is_on_wall() and not block_wall_slide:
			animated_sprite.play("wall_slide")
		else:
			animated_sprite.play("jump")
	else:
		if direction == 0:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("running")

func get_gravity(velocity_param: Vector2):
	if velocity_param.y < 0:
		return GRAVITY
	else: return FALL_GRAVITY

func _physics_process(delta):
	if is_on_floor():
		# Add squash effect
		if was_airbourne:
			animated_sprite.scale = Vector2(3.5, 2)
			was_airbourne = false
		# Always allow jump if on floor
		allow_jump = true
		coyote_timer.stop()
	else:
		# Start coyote timer
		if allow_jump and coyote_timer.is_stopped():
			coyote_timer.start()
		# Add gravity.
		velocity.y += get_gravity(velocity) * delta
		was_airbourne = true

	# Get the input direction and handle the movement/deceleration.
	var direction = Input.get_axis("left", "right")
	# Wall sliding
	if is_on_wall() and not is_on_floor() and direction != 0 and not block_wall_slide:
		velocity.y = float(GRAVITY) / 8

	# Animate sprite stretch
	if velocity.y < 0:
		animated_sprite.scale = Vector2(2.8, 3.5)

	# Handle movement
	if was_on_wall:
		# Allow for pushback when wall jumping
		if direction < 0 and ray_cast_left.is_colliding():
			pass
		elif direction > 0 and ray_cast_right.is_colliding():
			pass
		else:
			# To allow movement again once player is far away enough from wall
			was_on_wall = false
	else:
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, 30)

	# Allow player to jump normally even if jumping while bumping a wall
	if is_on_floor() and is_on_wall() and direction != 0:
		block_wall_slide = true
	if velocity.y > 0:
		block_wall_slide = false

	# To allow push back time when wall jumping
	if is_on_floor():
		was_on_wall = false

	# Handle jump
	if Input.is_action_just_pressed("jump"):
		if is_on_floor() or allow_jump: # Consider coyote time
			if is_on_wall() and direction!= 0:
				# Allow player to jump even if he's running towards a wall
				block_wall_slide = true
				velocity.y = JUMP_VELOCITY
			else:
				# Jump normally
				velocity.y = JUMP_VELOCITY
		elif is_on_wall():
			if direction < 0:
				was_on_wall = true
				#timer.start()
				velocity.y = WALL_JUMP_VELOCITY
				velocity.x = SPEED
			elif direction > 0:
				was_on_wall = true
				#timer.start()
				velocity.y = WALL_JUMP_VELOCITY
				velocity.x = -SPEED
		else:
			# Future for double jump feature
			pass

	# Fall at a greater speed
	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y = JUMP_VELOCITY / 4

	move_and_slide()
	handle_animation(direction)

	# Handle sprite's squash and stretch effect
	animated_sprite.scale.x = move_toward(animated_sprite.scale.x, 3, 3 * delta)
	animated_sprite.scale.y = move_toward(animated_sprite.scale.y, 3, 6 * delta)


func _on_coyote_timer_timeout():
	allow_jump = false
