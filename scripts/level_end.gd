extends Area2D

@export var target_level: PackedScene
@export var allow_navigate = false

func change_scene():
	get_tree().change_scene_to_packed(target_level)	

func _on_body_entered(_body):
	if allow_navigate:
		call_deferred("change_scene")
