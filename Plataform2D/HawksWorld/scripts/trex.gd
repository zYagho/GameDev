extends CharacterBody2D

const FIRE_BALL = preload("res://fire_ball.tscn")

@onready var anim = $anim
@onready var sprite = $sprite
@onready var fire_ball_spawn = $fire_ball_spawn
@onready var ground_detector = $ground_detector
@onready var player_detector = $player_detector
@onready var timer = $Timer

var move_speed = 50.0
var direction : int = 1
var health_points: int = 3
var new_fireball

enum EnemyState {PATROL, ATTACK, HURT}
var current_state = EnemyState.PATROL
@export var target: CharacterBody2D

func _physics_process(delta):
	match(current_state):
		EnemyState.PATROL : patrol_state()
		EnemyState.ATTACK : attack_state()
	
func attack_state():
	anim.play("shooting")
	if not player_detector.is_colliding():
		change_state(EnemyState.PATROL)
	
func patrol_state():
	anim.play("running")
	if is_on_wall():
		flip_enemy()
		
	if not (ground_detector.is_colliding()):
		flip_enemy()
		
	if player_detector.is_colliding():
		change_state(EnemyState.ATTACK)
		
	velocity.x = move_speed * direction
	move_and_slide()

func hurt_state():
	anim.play("hurt")
	await get_tree().create_timer(0.3).timeout
	change_state(EnemyState.PATROL)
	if health_points > 0:
		health_points -= 1
	else:
		Globals.score += 500
		queue_free()
func flip_enemy():
	direction *= -1
	sprite.scale.x *= -1
	player_detector.scale.x *= -1
	fire_ball_spawn.position.x *= -1

func spawn_fireball():
	new_fireball = FIRE_BALL.instantiate()
	if sign(fire_ball_spawn.position.x) == 1:
		new_fireball.set_direction(1)
	else:
		new_fireball.set_direction(-1)
	add_sibling(new_fireball)
	new_fireball.global_position = fire_ball_spawn.global_position
	
func change_state(state):
	current_state = state
	
func free_fire_ball():
	pass
func _on_hitbox_body_entered(body):
	change_state(EnemyState.HURT)
	hurt_state()
