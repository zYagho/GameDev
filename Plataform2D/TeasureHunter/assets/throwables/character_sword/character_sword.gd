extends ThrowableComponent
class_name CharacterSword

func _on_body_entered(_body) ->void:
	if _body is TileMap:
		queue_free()


func _on_visible_on_screen_enabler_2d_screen_exited():
	queue_free()
