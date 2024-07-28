extends AnimatableBody2D

var velocity: Vector2 = Vector2.ZERO
var direction: int = -1

@onready var sprite = $sprite

const SPEED: float = 128
const EXPLOSION = preload("res://prefabs/explosion.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	velocity.x = SPEED * direction * delta
	
	move_and_collide(velocity)


func _on_collision_detection_body_entered(body):
	visible = false
	var explosion_instance = EXPLOSION.instantiate()
	get_parent().add_child(explosion_instance)
	explosion_instance.global_position = global_position
	await explosion_instance.animation_finished
	queue_free()
	
func set_direction(dir):
	direction = dir
	if direction == 1:
		sprite.flip_h = true
	else:
		sprite.flip_h = true
		
