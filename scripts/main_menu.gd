extends Node
@export var level_buttons: Array[Node]

func _ready():
	for level in GameManager.available_levels:
		var level_btn = level_buttons[level - 1]
		level_btn.disabled = false

func _on_level_1_pressed():
	get_tree().change_scene_to_file("res://scenes/level1.tscn")

func _on_level_2_pressed():
	get_tree().change_scene_to_file("res://scenes/level2.tscn")

func _on_level_3_pressed():
	get_tree().change_scene_to_file("res://scenes/level3.tscn")
