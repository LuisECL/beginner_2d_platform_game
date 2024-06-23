extends Node

var score = 0
const MAX_SCORE = 5
@onready var score_label = $Score

func _ready():
	pass # Replace with function body.

func increase_score():
	score += 1

	if score == MAX_SCORE:
		score_label.text = "You've collected all the apples!"
		# Enable next level navigation
	else:
		if score == 1:
			score_label.text = "You've collected " + str(score) + " apple"
		else:
			score_label.text = "You've collected " + str(score) + " apples"
