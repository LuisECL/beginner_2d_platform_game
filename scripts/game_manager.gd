extends Node

var score = 0
@onready var score_label = $Score

func increase_score():
	score += 1
	score_label.text = "You've collected " + str(score) + " apples."
