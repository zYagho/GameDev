extends CharacterBody2D
class_name BaseEnemy

const _COLLECTABLE_ITEM: PackedScene = preload("res://assets/collectables/components/collectable_item.tscn")


var _gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var _on_floor: bool = false
var _direction: Vector2 = Vector2.ZERO
var _player_in_range: PlayerBase = null
var _is_alive: bool = true
var _on_knockback: bool = false
var _can_play_deadground: bool = true

enum _types {STATIC = 0, CHASE = 1, WANDER = 2}

var _drop_item_list: Dictionary = {}

@export_category("objects")
@export var _enemy_texture: EnemyTexture
@export var _floor_detection: RayCast2D
@export var _knockback_timer: Timer

@export_category("variables")
@export var _enemy_type: _types
@export var _move_speed: float = 128
@export var _knockback_speed: float = 128
@export var is_pink_star: bool = false
@export var _enemy_health: int = 5
@export var _knockback_timer_hit: float = 0.4
@export var _dead_knockback_timer: float = 0.4

func _ready() -> void:
	_direction = [Vector2(-1, 0), Vector2(1,0)].pick_random()
	_drop_item_list = _get_drop_items()
	_update_direction()
	
func _process(_delta)-> void:
	if _on_knockback:
		move_and_slide()
		return
		
func _physics_process(_delta) ->void:
	
	_verticalMovement(_delta)
	
	if !_is_alive:
		move_and_slide()
		return
	
	if is_instance_valid(_player_in_range):
		_attack()
	
	match _enemy_type:
		_types.STATIC:
			pass 
		_types.CHASE:
			pass
		_types.WANDER:
			_wandering()
		
	move_and_slide()
	
	_enemy_texture.animate(velocity)
	
func _get_drop_items() -> Dictionary:
	return {}
	
func _wandering() -> void:
	if _floor_detection.is_colliding():
		if _floor_detection.get_collider() is TileMap:
			velocity.x = _direction.x * _move_speed
			return
	
	#Se ele chegou aqui é porque atingiu o final da plataforma
	if is_on_floor():
		_update_direction()
		velocity.x = 0
	
func _verticalMovement(_delta: float) -> void:
	
	if is_on_floor():
		if !_is_alive:
			if _can_play_deadground:
				_can_play_deadground = false
				_enemy_texture.action_animate("dead_ground")
			velocity.x = 0
			return
		if  !_on_floor:
			_enemy_texture.action_animate("land")
			_on_floor = true
			
	
	if not is_on_floor():
		_on_floor = false
		velocity.y += _gravity * _delta

func _update_direction() -> void:
	_direction.x = - _direction.x
	if is_pink_star:
		if _direction.x > 0:
			_enemy_texture.flip_h = true
		if _direction.x < 0:
			_enemy_texture.flip_h = false
	if _direction.x > 0:
		_floor_detection.position.x = 12
	if _direction.x < 0:
		_floor_detection.position.x = -12

func _on_detection_area_body_entered(_body) -> void:
	if _body is PlayerBase:
		_player_in_range = _body

func _on_detection_area_body_exited(_body) -> void:
	if _body is PlayerBase:
		_player_in_range = null

func _attack():
	pass
	
	
func _kill() -> void:
	_is_alive = false
	_enemy_texture.action_animate("dead_hit")
	
	for _item in _drop_item_list:
		var _item_spawn_probability: float = _drop_item_list[_item]["spawn_probability"]
		var _rng: float = randf()
		
		if _rng < _item_spawn_probability:
			_drop_item(_item, _drop_item_list[_item])
			

	
func _drop_item(_item_name: String, _item_data: Dictionary) -> void:
	pass
	
func _knockback(_entity: PlayerBase) -> void:
	var _knockbackdirection: Vector2 = _entity.global_position.direction_to(global_position)
	velocity.x = _knockbackdirection.x * _knockback_speed
	velocity.y = _knockback_speed * (-1)
	_on_knockback = true
	
	
func update_health(_attack_damage: int, _entity) -> void:
	if !_is_alive:
		return
	_enemy_health -= _attack_damage
	
	_knockback(_entity)
	if _enemy_health <= 0:
		_knockback_timer.start(_dead_knockback_timer)
		_kill()
		return
		
	_knockback_timer.start(_knockback_timer_hit)
	_enemy_texture.action_animate("hit")


func _on_knockback_timer_timeout():
	_on_knockback = false
