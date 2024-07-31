extends AnimatedSprite2D
class_name EnemyTexture

var _on_action: bool = false

@export_category("objects")
@export var _enemy: BaseEnemy
@export var _attack_area_collision: CollisionShape2D

@export_category("variables")
@export var _last_attack_frame: int
@export var _initial_run_frame: int
@export var _last_run_frame: int 
@export var _x_attack_offset: float
@export var _y_attack_offset: float

func animate(_velocity: Vector2) -> void:
	if _on_action:
		return
	
	if _velocity.y: 
		if _velocity.y > 0:
			play("fall")
		if _velocity.y < 0:
			play("jump")
		return
	if _velocity.x:
		play("run")
		return
	
	play("idle")
	
func action_animate(_action: String) -> void:
	_enemy.set_physics_process(false)
	_on_action = true
	play(_action)
	
func _on_animation_finished() -> void:
	if animation == "attack_anticipation":
		action_animate("attack")
		return
	_enemy.set_physics_process(true)
	_on_action = false


func _on_frame_changed() -> void:
	
	if animation == "run":
		if frame == _initial_run_frame or frame == _last_run_frame:
			var _is_flipped: bool = flip_h
			if _enemy.is_pink_star:
				_is_flipped = not _is_flipped
			global.spawn_effect(
				"res://assets/visual_effects/dust_particles/run/run_effect.tscn",Vector2(0,4),global_position,_is_flipped
			)
	
	if animation == "attack":
		if frame == 0:
			global.spawn_effect(
				"res://assets/visual_effects/pink_star_attack/pink_star_attack.tscn",Vector2(_x_attack_offset,_y_attack_offset),global_position,flip_h
			)
		if frame == 1 or frame == 0:
			_attack_area_collision.disabled = false
		
		if frame == _last_attack_frame:
			_attack_area_collision.disabled = true
