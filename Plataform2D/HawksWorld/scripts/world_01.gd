extends Node2D

@onready var camera = $camera
@onready var player_scene = preload("res://actors/player.tscn")
@onready var player = $player
@onready var control = $HUD/control
@onready var player_start_position:Marker2D = $player_start_position

func _ready():
	Globals.player_start_position = player_start_position
	Globals.player = player
	Globals.player.follow_camera(camera)
	Globals.player.player_has_died.connect(reload_game)
	control.time_is_up.connect(game_over)
	
func reload_game():
	
	await get_tree().create_timer(1.0).timeout
	var player = player_scene.instantiate()
	add_child(player)
	control.reset_clock_timer()
	Globals.player = player
	Globals.player.follow_camera(camera)
	Globals.player.player_has_died.connect(reload_game)
	Globals.coins = 0
	Globals.score = 0
	Globals.player_life = 3
	Globals.respawn_player()
	
	
	
func game_over():
	get_tree().change_scene_to_file("res://prefabs/game_over.tscn")
