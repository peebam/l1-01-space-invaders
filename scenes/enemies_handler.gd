extends Node2D

const MoveHorizontal := 8
const MoveVertical := 24
const EnemyMargin := 16

enum States {
	MOVE_LEFT,
	MOVE_RIGHT,
	MOVE_DOWN
}

@onready var _lines_node: Node2D = %Lines

var _acceleration := 1.5
var _current_line := 0
var _enemy_scene: PackedScene = load("res://scenes/entities/enemy.tscn")
var _enemy_descrpition_yellow: EnemyDescription = load("res://assets/enemy_descriptions/yellow_enemy.tres")
var _enemy_descrpition_red: EnemyDescription = load("res://assets/enemy_descriptions/red_enemy.tres")
var _lines : Array[Node] = []
var _player_position : Vector2
var _previous_state : States = States.MOVE_RIGHT
var _state : States = States.MOVE_RIGHT

func _ready() -> void:
	Events.enemy_destroyed.connect(_on_enemy_destroy)
	Events.player_moved.connect(_on_Events_player_moved)

# Public

func new_run() -> int:
	var descriptions = [_enemy_descrpition_yellow, _enemy_descrpition_yellow, _enemy_descrpition_red, _enemy_descrpition_red]
	var nb_enemies := 11

	for d in descriptions.size():
		var line = _add_line(nb_enemies, descriptions[d])
		line.position.y = 10 + d * 30
		_lines.append(line)

	_lines.sort_custom(func(a: Node2D, b: Node2D) -> bool: return a.position.y > b.position.y)

	$MoveTimer.start(1.0 / _acceleration)
	$ShootTimer.start(2)

	return nb_enemies * descriptions.size()


func stop_run() -> void:
	for line in _lines:
		_lines_node.remove_child(line)
	_lines = []

	$MoveTimer.stop()
	$ShootTimer.stop()

# Private

func _add_line(nb: int, enemy_description: EnemyDescription) -> Node2D:
	var line := Node2D.new()
	_lines_node.add_child(line)

	for i in range(nb):
		var enemy: Enemy = _enemy_scene.instantiate()
		enemy.description = enemy_description
		line.add_child(enemy)
		enemy.position.x = i * 20 + 10

	return line


func _is_line_on_edge(line: Node) -> bool:
	var nb_children := line.get_child_count()
	if nb_children == 0:
		return true

	var first_child := line.get_child(0)
	var last_child := line.get_child(nb_children - 1)
	var viewport_rect := get_viewport_rect()

	return (last_child.global_position.x >= viewport_rect.position.x + viewport_rect.size.x - EnemyMargin
		or first_child.global_position.x <= viewport_rect.position.x + EnemyMargin)



func _move_down() -> void:
	_lines[_current_line].position.y += MoveVertical
	_current_line = (_current_line + 1) % _lines.size()

	if _current_line == 0:
		if _previous_state == States.MOVE_LEFT:
			_state = States.MOVE_RIGHT
		if _previous_state == States.MOVE_RIGHT:
			_state = States.MOVE_LEFT
		_previous_state = States.MOVE_DOWN


func _move_horizontal(direction: int) -> void:
	var line := _lines[_current_line]
	line.position.x += direction * MoveHorizontal
	_current_line = (_current_line + 1) % _lines.size()

	if _current_line == 0:
		if _is_line_on_edge(line):
			_previous_state = _state
			_state = States.MOVE_DOWN


func _move_left() -> void:
	_move_horizontal(-1)


func _move_right() -> void:
	_move_horizontal(1)


func _pick_enemy() -> Enemy:
	var enemies: Array[Enemy] = []
	enemies.assign(
		get_tree().
		get_nodes_in_group("enemies_group")
		.filter(func(n: Node) -> bool: return abs(n.global_position.x - _player_position.x) <=20))

	if enemies.is_empty():
		return null

	var enemy := enemies.pick_random() as Enemy
	return enemy

# Signals

func _on_enemies_timer_timeout() -> void:
	match _state:
		States.MOVE_LEFT:
			_move_left()
		States.MOVE_RIGHT:
			_move_right()
		_:
			_move_down()


func _on_enemy_destroy() -> void:
	_acceleration += 0.2
	$MoveTimer.wait_time = 1 / _acceleration


func _on_Events_player_moved(position_: Vector2) -> void:
	_player_position = position_


func _on_shoot_timer_timeout() -> void:
	var enemy := _pick_enemy()
	if enemy != null:
		enemy.shoot()
