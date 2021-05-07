extends Control

export(bool) var showing:=false
onready var pbar=$ProgressBar


	
func _process(delta):
	if !showing:
		return
	if Input.is_action_pressed("ui_accept"):
		pbar.value+=1
		if pbar.value==pbar.max_value:
			showing=false
			get_parent().fill_can()
			hide()
			


