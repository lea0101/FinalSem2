extends Control


var inventory:=["Hoe","Can","Seed1","Seed2","Seed3"]
var plants_val:=[5,10,30]

export(Array) var items
export(String) var equipped
export(int) var can_capacity
var money:=0
export(Array) var seedsprices=[1,5,10]

onready var slots:=$Slots
onready var ind:=$Rect_Indicator
onready var inv_item:=$Slots/TMP_Item
onready var pg_can:=$Prog_Can
onready var can_tip:=$RtLbl_CanTip
onready var closebtn:=$Btn_Close
onready var moneylbl:=$Lbl_Money

onready var ctrl_water:=$Fill_Water
onready var ctrl_shop:=$Shop
onready var ctrl_inv:=$Panel_Inv



func _ready():
	fill_can(0)
	equipped="Hoe"
	add_money(100)
	ctrl_shop.hide()
	ctrl_water.hide()


func _process(delta):
	if Input.is_action_pressed("num_1"):
		equip(1)
	elif Input.is_action_pressed("num_2"):
		equip(2)
	elif Input.is_action_pressed("num_3"):
		equip(3)
	elif Input.is_action_pressed("num_4"):
		equip(4)
	elif Input.is_action_pressed("num_5"):
		equip(5)


func equip(index):
	ind.rect_global_position=Vector2(175 + (index*100),520)
	equipped=inventory[index-1]
	for i in items:
		if i.name!=equipped:
			i.visible=false
			continue
		i.visible=true
		
func fill_can(x):
	if x==0:
		can_tip.show()
	else:
		can_tip.hide()
	can_capacity=x
	pg_can.value=x
	pg_can.get_child(0).text=str(can_capacity) + "%"


func _on_Btn_Close_button_down():
	ctrl_shop.hide()
	ctrl_water.toggle_show(0)
	closebtn.hide()
	
func add_money(change:int):
	money+=change
	moneylbl.text="$" + str(money)



func _on_Btn_Plant1_pressed():
	if(get_parent().plants_cnt[0]>0):
		add_money(5)
		get_parent().plants_cnt[0]-=1


func _on_Btn_Plant2_pressed():
	add_money(10)

func _on_Btn_Plant3_pressed():
	add_money(30)
	
func sell_crop(index:int):
	if(get_parent().plants_cnt[index]>0):
		add_money(plants_val[index])
		get_parent().plants_cnt[index]-=1
		ctrl_inv.update_cnt()
