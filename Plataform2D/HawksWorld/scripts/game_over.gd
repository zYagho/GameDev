extends Control

func _ready():
	Globals.coins = 0
	Globals.score = 0
	Globals.player_life = 3

func _on_restart_button_pressed():
	get_tree().change_scene_to_file("res://prefabs/title_screen.tscn")
 

func _on_quit_button_pressed():
	get_tree().quit()
