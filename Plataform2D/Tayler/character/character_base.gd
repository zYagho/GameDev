extends CharacterBody2D
class_name CharacterBase

@export_category("Variables")
@export var _speed: float = 128
@export var _jumpVelocity: float = -200

@export_category("Objects")
@export var _characterTexture: AnimatedSprite2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(_delta: float) -> void:
	
	_verticalMovement(_delta)
	_horizontalMovement()
	move_and_slide()
	_characterTexture.animate(velocity)

func _verticalMovement(_delta: float) -> void:
	pass

func _horizontalMovement() -> void:
	pass
	
