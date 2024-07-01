extends Area2D

func reload_level():
	get_tree().reload_current_scene()

func _on_body_entered(_body):
	call_deferred("reload_level")
