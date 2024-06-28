extends Area2D
@onready var level_manager = %LevelManager

func _on_body_entered(_body):
	level_manager.increase_score()
	queue_free()
