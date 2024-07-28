extends CharacterBody2D
class_name PlayerBase

const _THROWABLE_SWORD: PackedScene = preload("res://assets/throwables/character_sword/character_sword.tscn")

var _has_sword: bool = false
var _gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var _jump_count: int = 0
var _is_on_floor: bool = true
var _attack_index: int = 1
var _air_attack_count: int = 0

@export_category("variables")
@export var _speed: float = 150
@export var _jumpVelocity: float = -200

@export_category("Objects")
@export var _texture: PlayerTexture
@export var _attack_combo: Timer

func _physics_process(_delta: float) -> void:
	
	_verticalMovement(_delta)
	_horizontalMovement()
	_attack_handler()
	move_and_slide()
	_texture.animate(velocity)
	
func _verticalMovement(_delta: float) -> void:
	if is_on_floor():
		if !_is_on_floor:
			_air_attack_count = 0
			global.spawn_effect(
				"res://assets/visual_effects/dust_particles/fall/fall_effect.tscn",Vector2(0,2),global_position,false
			)
			_texture.action_animation("land")
			_is_on_floor = true
			set_physics_process(false)
		_jump_count = 0
	
	if not is_on_floor():
		if _is_on_floor:
			_attack_index = 1
		velocity.y += _gravity * _delta
		_is_on_floor = false
	if Input.is_action_just_pressed("jump") and _jump_count < 2:
		global.spawn_effect(
				"res://assets/visual_effects/dust_particles/jump/jump_effect.tscn",Vector2(0,2),global_position,_texture.flip_h
			)
		_attack_index = 1
		velocity.y = _jumpVelocity
		_jump_count += 1

func _horizontalMovement() -> void:
	var _direction = Input.get_axis("ui_left", "ui_right")
	if _direction:
		velocity.x = _direction * _speed
		return
	velocity.x = move_toward(velocity.x, 0, _speed)

func _attack_handler() -> void:
	if !_has_sword:
		return
		
	if Input.is_action_just_pressed("throw"):
		_texture.action_animation("throw_sword")
		set_physics_process(false)
		update_sword_state(false)
		return
		
	if Input.is_action_just_pressed("attack") and is_on_floor():
		_attack_animation_handller("attack_", 4)
		
	if (Input.is_action_just_pressed("attack") and not is_on_floor() and _air_attack_count < 2) :
		_attack_animation_handller("air_attack_", 3, true)
		
func _attack_animation_handller(_prefix: String, _index_limiar: int, _on_air: bool = false):
	
	global.spawn_effect(
		"res://assets/visual_effects/sword/" + _prefix + str(_attack_index) +
		 "/" + _prefix + str(_attack_index) + ".tscn",
		Vector2(24,0),global_position,_texture.flip_h
	)
	
	_texture.action_animation( _prefix + str(_attack_index))
	_attack_index +=1
	if _attack_index == _index_limiar:
		_attack_index = 1 
		
	set_physics_process(false)
	if _on_air:
		_air_attack_count += 1
	_attack_combo.start()
		
func throw_sword(_is_flipped: bool) -> void:
	
	var _sword: CharacterSword = _THROWABLE_SWORD.instantiate()
	get_tree().root.call_deferred("add_child", _sword)
	_sword.global_position = global_position
	
	if _is_flipped:
		_sword.direction = Vector2(-1, 0)
		return
	_sword.direction = Vector2(1, 0)
		
func update_sword_state(_state: bool) -> void:
	_has_sword = _state
	_texture.update_suffix(_has_sword)
	
func _on_attack_combo_timeout() -> void:
	_attack_index = 1
