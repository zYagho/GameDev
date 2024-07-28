extends CharacterBody2D
class_name BaseEnemy

var _gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var _on_floor: bool = false
var _direction: Vector2 = Vector2.ZERO
var _player_in_range: PlayerBase = null
var _is_alive: bool = true

enum _types {STATIC = 0, CHASE = 1, WANDER = 2}

@export_category("objects")
@export var _enemy_texture: EnemyTexture
@export var _floor_detection: RayCast2D
@export var _collision: CollisionShape2D

@export_category("variables")
@export var _enemy_type: _types
@export var _move_speed: float = 128
@export var _knockback_speed: float = 256.0 
@export var _pink_star_enemy: bool = false
@export var _enemy_health: int = 5
@export var _death_collision_offset: Vector2

func _ready() -> void:
	_direction = [Vector2(-1, 0), Vector2(1,0)].pick_random()
	
	if _pink_star_enemy:
		if _direction.x > 0:
			_enemy_texture.flip_h = true
		if _direction.x < 0:
			_enemy_texture.flip_h = false
	_update_direction()
	
func _physics_process(_delta) ->void:
	
	_verticalMovement(_delta)
	
	if !_is_alive:
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
	
func _wandering() -> void:
	if _floor_detection.is_colliding():
		if _floor_detection.get_collider() is TileMap:
			velocity.x = _direction.x * _move_speed
			return
	
	#Se ele chegou aqui é porque atingiu o final da plataforma
	_update_direction()
	velocity.x = 0
	
func _verticalMovement(_delta: float) -> void:
	
	if is_on_floor():
		if  !_on_floor:
			_enemy_texture.action_animate("land")
			_on_floor = true
			
	
	if not is_on_floor():
		_on_floor = false
		velocity.y += _gravity * _delta

func _update_direction() -> void:
	_direction.x = - _direction.x
	if _pink_star_enemy:
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
	_collision.position = _death_collision_offset
	_is_alive = false
	_enemy_texture.action_animate("dead_hit")
	
func _knockback(_entity) -> void:
	var _direction: Vector2 = global_position.direction_to(_entity.global_position)
	velocity.x = _direction.x * _knockback_speed
	velocity.y = _knockback_speed * (-1)
	move_and_slide()
	
func update_health(_attack_damage: int, _entity) -> void:
	if !_is_alive:
		return
	_enemy_health -= _attack_damage
	
	_knockback(_entity)
	if _enemy_health <= 0:
		_kill()
		return
		
	_enemy_texture.action_animate("hit")
