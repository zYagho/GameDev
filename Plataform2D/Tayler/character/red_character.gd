extends CharacterBase

func _verticalMovement(_delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * _delta

	if Input.is_action_just_pressed("red_space") and is_on_floor():
		velocity.y = _jumpVelocity

func _horizontalMovement() -> void:
	var direction = Input.get_axis("red_left", "red_right")
	if direction:
		velocity.x = direction * _speed
	else:
		velocity.x = move_toward(velocity.x, 0, _speed)
