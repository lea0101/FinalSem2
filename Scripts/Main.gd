extends Spatial

onready var player_sp:=$Spawnpoint
var player_prefab=preload("res://Scenes/PlayerTemp.tscn")

func _ready():
	var player=player_prefab.instance()
	player.global_transform=player_sp.global_transform
	add_child(player)

#the regular ground should be cobbles or something
