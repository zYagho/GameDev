extends CharacterBody2D

const SPEED = 100.0
const AIR_FRICTiON := 0.5

var is_hurted := false
var is_jumping := false
var gravity
var jump_velocity
var fall_gravity
var knockback_power:int = 20
var knockback_vector := Vector2.ZERO
var direction

@onready var jump: AudioStreamPlayer = $jump
@onready var anim = $anim
@onready var remote = $remote
@onready var destroy_box = preload("res://sounds/detroy_box.tscn")

@export var jump_height: int = 64
@export var max_time_to_peek: float = 0.5

signal player_has_died()

func _ready():
	jump_velocity = (jump_height * 2) / max_time_to_peek
	gravity = (jump_height * 2) / pow(max_time_to_peek, 2)
	fall_gravity = gravity * 2
	
func _physics_process(delta):

	if not is_on_floor():
		#velocity.y += gravity * delta
		velocity.x = 0
	#Apertou espaço
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = -jump_velocity
		jump.play()
	
	if velocity.y > 0 or not Input.is_action_pressed("ui_accept"):
		velocity.y += fall_gravity * delta
	else:
		velocity.y += gravity * delta
	#Dependendo do que for o input.
	direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = lerp(velocity.x, direction * SPEED, AIR_FRICTiON)
		anim.scale.x = direction
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	if knockback_vector != Vector2.ZERO:
		velocity = knockback_vector
		
	_set_state()
	move_and_slide()
	
	for plataforms in get_slide_collision_count():
		var collision := get_slide_collision(plataforms)
		if collision.get_collider().has_method("has_collided_whith"):
			collision.get_collider().has_collided_whith(collision, self)
	
func follow_camera(camera):
	var camera_path = camera.get_path()
	remote.remote_path = camera_path

func _on_hurtbox_body_entered(body):
	var knoback = Vector2((global_position.x - body.global_position.x) * knockback_power, -200)
	take_damage(knoback)
	if body.is_in_group("fireball"):
		body.queue_free()
		
func take_damage(knockback_force := Vector2.ZERO, duration := 0.25):
	#Fazendo o player tomar dano
	
	if Globals.player_life == 1:
		queue_free()
		emit_signal("player_has_died")
	Globals.player_life -= 1

	if knockback_force != Vector2.ZERO:
		knockback_vector = knockback_force
	
		var knockback_tween := get_tree().create_tween()
		knockback_tween.parallel().tween_property(self, "knockback_vector", Vector2.ZERO, duration)
		anim.modulate = Color(1, 0, 0, 1)
		knockback_tween.parallel().tween_property(anim, "modulate", Color(1,1,1,1), duration)
	
	is_hurted = true
	await get_tree().create_timer(.3).timeout
	is_hurted = false
	
func _set_state():
	var state = "idle"
	
	if !is_on_floor():
		state = "jump"
	elif direction != 0:
		state = "run"
		
	if is_hurted:
		state = "hurt"
		
	if anim.name != state:
		anim.play(state)

func _on_head_collider_body_entered(body):
	if body.has_method("break_sprite"):
		body.hit_point -=1
		if body.hit_point == 0:
			play_destroy_box()
			body.break_sprite()
		else:
			body.hit_block.play()
			body.anim.play("hit")
			body.create_coin()

func play_destroy_box():
	var sound = destroy_box.instantiate()
	get_parent().add_child(sound)
	sound.play()
	await  sound.finished
	sound.queue_free()
	
