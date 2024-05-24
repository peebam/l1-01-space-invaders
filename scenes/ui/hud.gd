extends Control

func _ready() -> void:
	Events.lives_updated.connect(_on_Events_lives_updated)
	Events.score_updated.connect(_on_Events_score_updated)



func _on_Events_lives_updated(score: int) -> void:
	$MarginContainer/HBoxContainer/LivesCounterLabel.text = ("%d" % score)


func _on_Events_score_updated(score: int) -> void:
	$MarginContainer/HBoxContainer/ScoreCounterLabel.text = ("%06d" % score)
