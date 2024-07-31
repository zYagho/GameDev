extends CharacterBody2D
class_name PlayerBase

const _THROWABLE_SWORD: PackedScene = preload("res://assets/throwables/character_sword/character_sword.tscn")

var _has_sword: bool = false
var _gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var _jump_count: int = 0
var _is_on_floor: bool = true
var _attack_index: int = 1
var _air_attack_count: int = 0
var _on_knockback: bool = false
var _is_alive: bool = true
var _can_play_deadground: bool = true

@export_category("variables")
@export var _speed: float = 150
@export var _jumpVelocity: float = -200
@export var _character_health: int = 3
@export var _knockback_speed: float = 128

@export_category("Objects")
@export var _texture: PlayerTexture
@export var _attack_combo: Timer
@export var _knockback_timer: Timer
@export var _collision: CollisionShape2D 

func _process(_delta) -> void:
	if _on_knockback:
		move_and_slide()
	

func _physics_process(_delta: float) -> void:
	
	_verticalMovement(_delta)
	
	if !_is_alive or _on_knockback:
		move_and_slide()
		return
	_horizontalMovement()
	_attack_handler()
	move_and_slide()
	_texture.animate(velocity)
	
func _verticalMovement(_delta: float) -> void:
	if !_can_play_deadground:
		velocity.y = 0
		return
	if is_on_floor():
		if !_is_alive:
			if _can_play_deadground:
				_can_play_deadground = false
				_collision.disabled = true
				_texture.action_animation("dead_ground")
			velocity.x = 0
			return
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
	
func update_health(_value: int, _entity) -> void:
	_knockback(_entity)
	_knockback_timer.start()
	_character_health -= _value
	if _character_health <= 0:
		update_sword_state(false)
		_is_alive = false
		_texture.action_animation("dead_hit")
		return
	
	_texture.action_animation("hit")

func _knockback(_entity: BaseEnemy) -> void:
	var _knockback_direction: Vector2 = _entity.global_position.direction_to(global_position)
	velocity.x = _knockback_direction.x * _knockback_speed
	velocity.y = -1 * _knockback_speed
	_on_knockback = true

func _on_knockback_timer_timeout() -> void:
	_on_knockback = false
	
func is_player_alive() -> bool:
	return _is_alive
