extends Area2D

var had_wall_jump_powerup = GameManager.power_ups['wall_jump']

func _on_body_entered(_body):
	if (had_wall_jump_powerup):
		GameManager.power_ups['wall_jump'] = false

func _on_body_exited(_body):
	if (had_wall_jump_powerup):
		GameManager.power_ups['wall_jump'] = true
