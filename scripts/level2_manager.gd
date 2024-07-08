extends Node

var score = 0
const MAX_SCORE = 10
@onready var score_label = $Score
@onready var level_end = %LevelEnd
@onready var apple_count = %AppleCount

func _ready():
	GameManager.power_ups.wall_jump = true

func increase_score():
	score += 1
	apple_count.text = str(score)

	if score == MAX_SCORE:
		score_label.text = "You've collected all the apples!"
		# Enable next level navigation
		level_end.get_node("Sprite2D").modulate.a = 1
		level_end.allow_navigate = true
	else:
		var missing = MAX_SCORE - score
		if missing == 1:
			score_label.text = str(missing) + " apple missing"
		else:
			score_label.text = str(missing) + " apples missing"
