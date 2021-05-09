extends Area

var player=null

func _on_TMP_WaterStation_body_entered(body):
	if "Player" in body.name:
		player=body
		send_menu_trigger("Water")
		
func _on_TMP_Shop_body_entered(body):
	if "Player" in body.name:
		player=body
		send_menu_trigger("Shop")


func send_menu_trigger(menu_name:String):
	if player!=null:
		player.open_menu(menu_name)



