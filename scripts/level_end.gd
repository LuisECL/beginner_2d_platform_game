extends Area2D

@export var target_level: PackedScene
@export var allow_navigate = false
@export var unlock_level: int
@export var unlock_powerup: String

func change_scene():
	get_tree().change_scene_to_packed(target_level)	

func _on_body_entered(_body):
	if allow_navigate:
		call_deferred("change_scene")
	if (unlock_level):
		GameManager.available_levels.append(unlock_level)
	if (unlock_powerup):
		GameManager.power_ups[unlock_powerup] = true
