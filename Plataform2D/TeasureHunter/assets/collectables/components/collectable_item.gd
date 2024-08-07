extends RigidBody2D
class_name CollectableItem

var item_data: Dictionary
var item_texture: String

@export_category("Object")
@export var _item_sprite: Sprite2D

func _ready() -> void:
	_item_sprite.texture = load(item_texture)
	apply_impulse(Vector2([-100, 100].pick_random(), -200))


func _on_collectable_area_body_entered(_body) -> void:
	if _body is PlayerBase:
		_body.collect_item(item_data)
		global.spawn_effect(
			"res://assets/visual_effects/coin_effect/coin_effect.tscn",
			Vector2.ZERO,
			global_position,
			false
		)
		queue_free()
	pass # Replace with function body.
