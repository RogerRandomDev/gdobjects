extends Node

var player=null
var ProjectileHolder=null

func _ready():
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
func get_player():return player
