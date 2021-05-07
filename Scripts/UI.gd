extends Control


var inventory:=["Hoe","Can","Seed","",""]
export(Array) var items
export(String) var equipped
export(int) var can_capacity

onready var slots:=$Slots
onready var ind:=$Rect_Indicator
onready var inv_item:=$Slots/TMP_Item
onready var pg_can:=$Prog_Can

func _ready():
	can_capacity=0
	equipped="Hoe"

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
		
func fill_can():
	can_capacity=100
	pg_can.value=can_capacity
	pg_can.get_child(0).text=str(can_capacity) + "%"
	
	

