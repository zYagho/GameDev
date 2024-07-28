extends Area2D
class_name  ThrowableComponent

@export_category("variables")
@export var _move_speed: float = 128.0

var direction: Vector2

func _on_body_entered(_body) ->void:
	pass # Replace with function body.


func _physics_process(_delta) ->void:
	translate(direction * _delta * _move_speed)
	pass


func _on_visible_on_screen_enabler_2d_screen_exited():
	pass # Replace with function body.
