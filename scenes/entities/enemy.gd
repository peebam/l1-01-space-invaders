class_name Enemy extends Area2D

@export var description : EnemyDescription

@onready var _animated_sprite: AnimatedSprite2D = %AnimatedSprite

func _ready() -> void:
	_animated_sprite.sprite_frames = description.sprite_frames
	_animated_sprite.play("default")

# Public

func destroy() -> void:
	collision_layer = 0
	_animated_sprite.play("explode")
	_animated_sprite.animation_finished.connect(_on_destroyed)


func shoot():
	Events.enemy_shot.emit(global_position + Vector2(0, 10), Vector2.DOWN)


func _on_destroyed() -> void:
	Events.enemy_destroyed.emit()
	queue_free()
