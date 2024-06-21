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
@onready var animated_sprite = $AnimatedSprite2D
@onready var timer = $Timer

func get_gravity(velocity_param: Vector2):
	if velocity_param.y < 0:
		return GRAVITY
	else: return FALL_GRAVITY

func _physics_process(delta):
	# Add gravity.
	if is_on_floor():
		if was_airbourne:
			animated_sprite.scale = Vector2(3.5, 2)
			was_airbourne = false
	else:
		animated_sprite.play('jump')
		velocity.y += get_gravity(velocity) * delta
		was_airbourne = true
	
	# Get the input direction and handle the movement/deceleration.
	var direction = Input.get_axis("left", "right")
	# Running
	if direction > 0:
		animated_sprite.flip_h = false
		animated_sprite.play("running")
	elif direction < 0:
		animated_sprite.flip_h = true
		animated_sprite.play("running")
	else:
		animated_sprite.play("idle")
	# Wall sliding
	if is_on_wall() and not is_on_floor() and direction != 0 and not block_wall_slide:
		animated_sprite.play("wall_jump")
		velocity.y = GRAVITY / 8

	# Animate sprite stretch
	if velocity.y < 0:
		animated_sprite.scale = Vector2(2.8, 3.5)
	
	# Handle movement
	if was_on_wall:
		# Allow for pushback when wall jumping
		pass
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
	if timer.is_stopped() || is_on_floor():
		was_on_wall = false
	
	# Handle jump
	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y = JUMP_VELOCITY / 4
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = JUMP_VELOCITY
		elif is_on_floor() and is_on_wall() and direction != 0:
			block_wall_slide = true
		elif is_on_wall() and direction < 0:
			was_on_wall = true
			timer.start()
			velocity.y = WALL_JUMP_VELOCITY
			velocity.x = SPEED
		elif is_on_wall() and direction > 0:
			was_on_wall = true
			timer.start()
			velocity.y = WALL_JUMP_VELOCITY
			velocity.x = -SPEED

	move_and_slide()
	
	animated_sprite.scale.x = move_toward(animated_sprite.scale.x, 3, 3 * delta)
	animated_sprite.scale.y = move_toward(animated_sprite.scale.y, 3, 6 * delta)


func _on_timer_timeout():
	was_on_wall = false # Replace with function body.
