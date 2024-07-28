extends ParallaxBackground
class_name BackGround

@onready var _clouds: Array = [
	$cloudT1, $cloudT2, $cloudT3, $cloudT4,
	$cloudT5, $cloudT6, $cloudT7, $cloudT8
]

var _speed_values: Array[float] = [
	16.0 , 16.0 , 4.0, 4.0, 8.0, 8.0, 12.0, 12.0
]

#Fazendo as Nuvens se mover com velocidades diferentes.
func _physics_process(_delta: float) -> void:
	var _i: int = 0 
	for cloud in _clouds:
		cloud.motion_offset.x -= _speed_values[_i] * _delta
		_i += 1
