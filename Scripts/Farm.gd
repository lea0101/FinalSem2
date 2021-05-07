extends StaticBody




func _on_Area_body_entered(body):
	if "Player" in body.name:
		body.on_farm=true




func _on_Area_body_exited(body):
	if "Player" in body.name:
		body.on_farm=false
