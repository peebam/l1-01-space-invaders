class_name Game extends Node2D

signal run_failed()
signal run_won()

const PLAYER_NODE_NAME = "Player"

var _player_scene: PackedScene = load("res://scenes/entities/player.tscn")

var _lives : int : set = _set_lives
var _nb_enemies : int
var _score : int : set = _set_score

func _ready() -> void:
	Events.enemy_destroyed.connect(_on_Events_enemy_destroyed)
	Events.player_destroyed.connect(_on_Events_player_destroyed)


func _draw() -> void:
	for i in range(50):
		var viewport_react := get_viewport_rect()
		var position = Vector2(randf() * viewport_react.size.x, randf() * viewport_react.size.y)
		var gray = randf()
		draw_circle(position + viewport_react.position, 0.5, Color(gray, gray, gray))

# Private

func _add_player() -> void:
	_remove_player()

	var player : Player = get_node(PLAYER_NODE_NAME)
	player = _player_scene.instantiate()
	player.name = PLAYER_NODE_NAME
	player.position = Vector2(10, 270)
	add_child(player)


func _new_run() -> void:
	_nb_enemies = $EnemiesHandler.new_run()
	_add_player()
	_lives = 2
	_score = 0


func _remove_player() -> void:
	if has_node(PLAYER_NODE_NAME):
		remove_child(get_node(PLAYER_NODE_NAME))


func _set_lives(value: int) -> void:
	_lives = value
	Events.lives_updated.emit(_lives)


func _set_score(value: int) -> void:
	_score = value
	Events.score_updated.emit(_score)

# Signals

func _on_Events_enemy_destroyed() -> void:
	_score += 10
	_nb_enemies -= 1

	if _nb_enemies == 0:
		run_won.emit()


func _on_Events_player_destroyed() -> void:
	if (_lives == 0):
		run_failed.emit()
	else:
		_lives -= 1
		_add_player()


func _on_main_menu_quiited() -> void:
	get_tree().quit()


func _on_main_menu_run_started() -> void:
	_new_run()
	$CanvasLayer/MainMenu.visible = false
	$CanvasLayer/HUD.visible = true


func _on_run_failed() -> void:
	$EnemiesHandler.stop_run()
	$CanvasLayer/HUD.visible = false
	$CanvasLayer/RunFailedMenu.visible = true


func _on_run_failed_menu_main_menu() -> void:
	$CanvasLayer/MainMenu.visible = true
	$CanvasLayer/RunFailedMenu.visible = false


func _on_run_won() -> void:
	_remove_player()
	$EnemiesHandler.stop_run()
	$CanvasLayer/HUD.visible = false
	$CanvasLayer/RunWonMenu.visible = true


func _on_run_won_menu_main_menu() -> void:
	$CanvasLayer/MainMenu.visible = true
	$CanvasLayer/RunWonMenu.visible = false

