extends Node

var score = 0
const MAX_SCORE = 5
@onready var score_label = $Score
@onready var level_end = %LevelEnd

func increase_score():
	score += 1

	if score == MAX_SCORE:
		score_label.text = "You've collected all the apples!"
		# Enable next level navigation
		level_end.get_node("Sprite2D").modulate.a = 1
		level_end.allow_navigate = true
	else:
		if score == 1:
			score_label.text = "You've collected " + str(score) + " apple"
		else:
			score_label.text = "You've collected " + str(score) + " apples"
