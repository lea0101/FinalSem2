extends Control

export(bool) var showing:=false
onready var pbar=$ProgressBar


	
func _process(delta):
	if !showing:
		return
	if Input.is_action_pressed("ui_accept"):
		pbar.value+=1
		if pbar.value==pbar.max_value:
			get_parent().fill_can(100)
			toggle_show(0)
			pbar.value=0
			

func toggle_show(v:int):
	if v==0:
		hide()
		showing=false
		get_parent().closebtn.hide()
		return
	show()
	showing=true


