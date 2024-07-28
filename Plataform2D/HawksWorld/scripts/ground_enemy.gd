extends Enemy_Base

func _ready():
	collision_detector = $collision_detector
	texture = $texture
	anim.animation_finished.connect(kill_ground_enemy)
	
func _physics_process(delta):
	apply_gravity(delta)
	movement(delta)
	flip_direction()
