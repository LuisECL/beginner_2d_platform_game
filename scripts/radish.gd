extends RigidBody2D
@onready var level_manager = %LevelManager

## Called when the node enters the scene tree for the first time.
#func _ready():
	#pass # Replace with function body.
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass

func _on_hit_zone_body_entered(body):
	var y_delta = position.y - body.position.y
	var x_delta = body.position.x - position.x
	if (y_delta < 60):
		# Character collides from the side
		level_manager.decrease_health()
		body.got_hit = true
		if (x_delta > 0):
			body.jump_away(750)
		else:
			body.jump_away(-750)
	else:
		# Character collides from the top		
		queue_free()
		body.bounce_off()
		body.got_hit = false
