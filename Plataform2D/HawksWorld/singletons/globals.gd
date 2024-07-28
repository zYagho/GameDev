extends Node

var coins: int = 0
var score: int = 0
var player_life: int = 3

var player = null
var current_checkpoint = null
var player_start_position = null

func respawn_player():
	if current_checkpoint != null:
		player.position = current_checkpoint.global_position
	else:
		player.global_position = player_start_position.global_position
