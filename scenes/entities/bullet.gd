class_name Bullet extends AnimatedSprite2D

const SPEED := 400

@export_flags_2d_physics var collision_mask
@export var direction := Vector2.ZERO

var _ray_cast: RayCast2D

func _ready() -> void:
	play()
	_ray_cast = $RayCast2D
	_ray_cast.collision_mask = collision_mask

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	position = position + direction * SPEED * delta

	_ray_cast.force_raycast_update()
	if _ray_cast.is_colliding():
		var collider = _ray_cast.get_collider()
		if collider is Enemy or collider is Player:
			collider.destroy()
			queue_free()


