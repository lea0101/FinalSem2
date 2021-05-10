extends Panel

onready var anim:=$AnimationPlayer
onready var ctrl_cnt:=$Plants_Labels


func _ready():
	rect_global_position=Vector2(-254.373, 134.695)


func _on_Btn_OpenMenu_toggled(button_pressed):
	if button_pressed:
		anim.play("open")
	else:
		anim.play_backwards("open")

func update_cnt():
	var cnt = 0
	for i in ctrl_cnt.get_children():
		i.text=str(get_parent().get_parent().plants_cnt[cnt]) + "x"
		cnt+=1
