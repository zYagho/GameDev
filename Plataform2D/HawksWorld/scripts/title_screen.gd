extends Control




func _on_start_btn_pressed():
	get_tree().change_scene_to_file("res://levels/world_01.tscn")


func _on_credits_btn_pressed():
	pass

func _on_quit_btn_pressed():
	get_tree().quit()
