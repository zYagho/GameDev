extends CharacterBody2D
class_name Enemy_Base

@onready var anim = $anim

@export var enemy_score: int = 100

const SPEED = 700.0
const JUMP_VELOCITY = -400.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction := -1
var texture
var collision_detector
var can_spawn := false
var spawn_instance: PackedScene = null
var spawn_intance_position

func apply_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

func movement(delta):
	velocity.x = direction * SPEED * delta	
	move_and_slide()

func flip_direction():
	if collision_detector.is_colliding():
		direction *= -1
		collision_detector.scale.x *= -1
		
	if direction == 1:
		texture.flip_h = true
	else:
		texture.flip_h = false

func kill_ground_enemy(anim_name: String) -> void:
	kill_and_score()
	
func kill_and_score():
	Globals.score += enemy_score

	if can_spawn:
		spawn_new_enemy()
		get_parent().queue_free()
	else:
		queue_free()

func kill_air_enemy():
	kill_and_score()
	
func spawn_new_enemy():
	var instance_scene = spawn_instance.instantiate()
	get_tree().root.add_child(instance_scene)
	instance_scene.global_position = spawn_intance_position.global_position
	
