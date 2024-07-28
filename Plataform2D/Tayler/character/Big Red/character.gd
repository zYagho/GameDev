extends CharacterBody2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var _gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var _jump_count: int = 0
var _is_on_floor: bool = true

@export_category("variables")
@export var _speed: float = 100
@export var _jump_velocity: float = -250

@export_category("objects")
@export var _character_texture: CharacterTexture

func _physics_process(_delta):
	
	_vertical_movement(_delta)
	_horizontal_movement()
	move_and_slide()
	_character_texture.animate(velocity)
	
func _vertical_movement(_delta: float) -> void:
	#se ele não está no chão
	if not is_on_floor():
		if _is_on_floor:
			pass #tocar a animcação de jump
		velocity.y += _gravity * _delta
		_is_on_floor = false
		
	#se ele está no chão
	if is_on_floor():
		if !_is_on_floor:
			pass	#tocar a animação de fall
			
		_jump_count = 0
		_is_on_floor = true

	if Input.is_action_just_pressed("ui_accept") and _jump_count < 2:
		velocity.y = _jump_velocity
		_jump_count += 1
	
func _horizontal_movement() -> void:
	
	var _direction = Input.get_axis("ui_left", "ui_right")
	if _direction:
		velocity.x = _direction * _speed
		return
	velocity.x = move_toward(velocity.x, 0, _speed)
