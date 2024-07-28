extends CollectableComponent
class_name CollectableSword

func _consume(_body: PlayerBase) -> void:
	print(_body)
	_body.update_sword_state(true)
