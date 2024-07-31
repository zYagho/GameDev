extends Area2D
class_name CharacterAttackArea

@export_category("variables")
@export var _attack_damage: int = 1

func _on_body_entered(_body):
	if _body is BaseEnemy:
		_body.update_health(_attack_damage, get_parent())

