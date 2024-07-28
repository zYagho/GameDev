extends ParallaxBackground
class_name BackGround

@onready var _cloud_cover_1 = $cloud_cover_1

@export_category("variables")
@export var _speed_cloud: float = 8

func _physics_process(_delta) -> void:
	_cloud_cover_1.motion_offset.x -= _delta * _speed_cloud
