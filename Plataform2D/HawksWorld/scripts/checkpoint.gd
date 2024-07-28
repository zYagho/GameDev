extends Area2D

var is_active: bool = false
@onready var anim = $anim
@onready var control = $"../../HUD/control"


func _on_body_entered(body):
	if body.name != "player" or is_active:
		return
	activate_cheackpoint()

func activate_cheackpoint():
	Globals.current_checkpoint = self
	control.reset_clock_timer()
	anim.play("raising")
	is_active = true


func _on_anim_animation_finished():
	if anim.animation == "raising":
		anim.play("checked")
		
