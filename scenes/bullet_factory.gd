extends Node2D

@export_flags_2d_physics var enemy_bullet_collision_mask
@export_flags_2d_physics var player_bullet_collision_mask

var _bullet_scene: PackedScene = load("res://scenes/entities/bullet.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Events.enemy_shot.connect(_on_Events_enemy_shot)
	Events.player_shot.connect(_on_Events_player_shot)


func _on_Events_enemy_shot(position: Vector2, direction: Vector2):
	var bullet: Bullet = _bullet_scene.instantiate()
	bullet.collision_mask = enemy_bullet_collision_mask
	bullet.direction = direction
	bullet.position = position
	add_child(bullet)

func _on_Events_player_shot(position: Vector2, direction: Vector2):
	var bullet: Bullet = _bullet_scene.instantiate()
	bullet.collision_mask = player_bullet_collision_mask
	bullet.direction = direction
	bullet.position = position
	add_child(bullet)
