extends Control

func _ready() -> void:
	$ScoreLabel.text = "SCORE: 0"
	Global.score_label = $ScoreLabel
	Global.score_node = self


# Update the score when the player kill an enemy.
# - [enemy_score: int] - The enemy's score.
func update_score(enemy_score: int) -> void:
	if Global.player != null:
		var score_rules: Array = Global.score_label.text.split(" ")
		var new_score: int = int(score_rules[1]) + enemy_score

		Global.score_label.text = "SCORE: " + str(new_score)
