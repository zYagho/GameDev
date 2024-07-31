extends AnimatedSprite2D
class_name CharacterBaseTexture

var _is_action: bool = false

func animate(_velocity: Vector2) -> void:
	
	if _is_action:
		return
		
	if _velocity.y:
		#Relembar a cada personagem o nome das animações e se eles vão ter animação de Fall
		play("jump")
		return
		
	if _velocity.x:
		play("run")
	
	if !_velocity.x and !_velocity.y:
		play("idle")
