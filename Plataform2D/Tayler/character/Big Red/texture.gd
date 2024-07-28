extends AnimatedSprite2D
class_name CharacterTexture

var _is_on_action: bool = false

func animate(_velocity: Vector2) -> void:
	if _is_on_action:
		return
	
	_direction(_velocity.x)
	
	if _velocity.y:
		play("jump_fall")
		return
	
	if _velocity.x and !_velocity.y:
		play("run")
		return
	
	if !_velocity.x and !_velocity.y:
		play("idle")

func _direction(_direction: int) -> void:
	if _direction >= 0:
		flip_h = false
		return
	flip_h = true
	return
