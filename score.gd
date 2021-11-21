extends Label

onready var prefix := "Score: "
onready var score : float = 0.0

func update_score(score: float) -> void:
	text = prefix + str(score)


func _on_ScoreTimer_timeout() -> void:
	score += 1.0
	update_score(score)
