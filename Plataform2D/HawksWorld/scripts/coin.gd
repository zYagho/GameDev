extends Area2D

@onready var anim = $anim
@onready var coin_sound: AudioStreamPlayer = $coin

var coin = 1

func _on_body_entered(body):
	if body.name == "player":
		anim.play("collect")
		coin_sound.play()
		await  $collision.call_deferred("queue_free")
		Globals.coins += coin

func _on_anim_animation_finished():
	queue_free()
