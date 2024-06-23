extends Area2D

@export var target_level: PackedScene

func change_scene():
	get_tree().change_scene_to_packed(target_level)	

func _on_body_entered(_body):
	call_deferred("change_scene")
