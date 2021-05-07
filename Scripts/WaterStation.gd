extends Area

func _on_TMP_WaterStation_body_entered(body):
	if "Player" in body.name:
		body.start_fill()
