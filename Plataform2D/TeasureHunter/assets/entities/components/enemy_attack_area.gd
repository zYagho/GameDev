extends Area2D
class_name  EnemyAtacckArea

@export_category("Variables")
@export var _attack_damage: int = 1

func _on_body_entered(_body) -> void:
	if _body is PlayerBase:
		#_body.update_health()
		print("causar dano")
		pass
