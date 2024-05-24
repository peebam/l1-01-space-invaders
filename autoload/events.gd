extends Node

signal enemy_destroyed()
signal enemy_shot(from: Vector2, direction: Vector2)
signal lives_updated(lives: int)
signal player_destroyed()
signal player_moved(postion: Vector2)
signal player_shot(from: Vector2, direction: Vector2)
signal score_updated(score: int)
