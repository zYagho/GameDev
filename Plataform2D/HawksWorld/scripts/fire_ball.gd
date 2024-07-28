extends CharacterBody2D

var move_speed = 80.0
var direction :int = 1 
 
func _process(delta):
	position.x += move_speed * direction * delta

func set_direction(dir):
	direction = dir
	if dir < 0:
		$sprite.flip_h = true
	else:
		$sprite.flip_h = false

func _on_visible_on_screen_enabler_2d_screen_exited():
	queue_free()
