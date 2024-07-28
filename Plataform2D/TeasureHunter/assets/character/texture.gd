extends AnimatedSprite2D
class_name PlayerTexture

var _is_on_action: bool = false
var _suffix: String = ""

@export_category("objects")
@export var _player: PlayerBase
@export var _attack_area_collision: CollisionShape2D


func animate(_velocity: Vector2) -> void:
	
	if _is_on_action:
		return
		
	_direction(_velocity.x)

	if _velocity.y:
		if _velocity.y > 0:
			play("fall" + _suffix)
		if _velocity.y < 0:
			play("jump" + _suffix)
		return
		
	if _velocity.y == 0 and _velocity.x != 0:
		play("run" + _suffix)
		return
	if _velocity.x == 0 and _velocity.y == 0:
		play("iddle" + _suffix)
		return
		
func _direction(_direction:  int) -> void:
	if _direction >= 0:
		flip_h = false
		_attack_area_collision.position.x = 24
		return
	flip_h = true
	_attack_area_collision.position.x = -24
	return
	
func action_animation(_action_name: String) -> void:
	_is_on_action = true
	if _action_name == "throw_sword":
		play(_action_name)
		return
		
	play(_action_name + _suffix)

func _on_animation_finished():
	_is_on_action = false
	_player.set_physics_process(true)

func update_suffix(_state: bool) -> void:
	if _state:
		_suffix = "_with_sword"
		return
	_suffix = ""


func _on_frame_changed() -> void:
	var _current_animation: StringName = animation
	
	if _current_animation.begins_with("air_attack") or _current_animation.begins_with("attack"):
		if _current_animation.begins_with("air_attack"):
			_attack_area_collision.position.y = 24
		if  _current_animation.begins_with("attack"):
			_attack_area_collision.position.y = 0
			
		if frame == 0 or frame == 1:
			_attack_area_collision.disabled = false
		if frame == 2:
			_attack_area_collision.disabled = true
	
	if animation == "throw_sword":
		if frame == 2:
			_player.throw_sword(flip_h)
			
	if animation == "run" or animation == "run_with_sword":
		if frame == 1 or frame == 4:
			global.spawn_effect(
				"res://assets/visual_effects/dust_particles/run/run_effect.tscn",Vector2(0,2),global_position,flip_h
			)
			
