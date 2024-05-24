class_name Player extends Area2D

const MOVE_SPEED := 100.0
const SPRITE_SIZE := Vector2(16, 16)

@onready var _animated_sprite: AnimatedSprite2D = $AnimatedSprite

func _ready() -> void:
	_animated_sprite.play("default")


func _process(delta: float) -> void:
	if Input.is_action_pressed("ui_left"):
		_move(-delta * MOVE_SPEED)

	if Input.is_action_pressed("ui_right"):
		_move(delta * MOVE_SPEED)

	if Input.is_action_just_pressed("ui_fire"):
		_shoot()

# Public

func destroy() -> void:
	_animated_sprite.play("explode")
	await _animated_sprite.animation_finished
	Events.player_destroyed.emit()
	queue_free()

# Private

func _move(offset: float):
		var boudaries := get_viewport_rect()
		position.x = clampf(
			position.x + offset,
			boudaries.position.x + SPRITE_SIZE.x / 2,
			boudaries.position.x + boudaries.size.x - SPRITE_SIZE.x / 2)

		Events.player_moved.emit(position)


func _shoot():
	Events.player_shot.emit(global_position - Vector2(0, 10), Vector2.UP)

