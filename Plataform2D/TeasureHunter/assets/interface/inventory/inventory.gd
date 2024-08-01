extends Control
class_name UIInventory

const _INVENTORY_SLOT: PackedScene = preload("res://assets/interface/inventory/inventory_slot.tscn")
const _INVENTORY_SIZE: int = 18

@export_category("Objects")
@export var _slot_container: GridContainer

func _ready() ->void:
	for _i in _INVENTORY_SIZE:
		var _inventory_slot: UIInventorySlot = _INVENTORY_SLOT.instantiate()
		_slot_container.add_child(_inventory_slot)
