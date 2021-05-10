extends Spatial

onready var player_sp:=$Spawnpoint
var player_prefab=preload("res://Scenes/Player.tscn")

func _ready():
	var player=player_prefab.instance()
	player.global_transform=player_sp.global_transform
	add_child(player)

