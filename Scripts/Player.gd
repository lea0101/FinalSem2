extends KinematicBody


export(bool) var on_farm=false
export(Array) var seeds_cnt=[0,0,0]

#bools
var jumping:=false

#physics
var gravity:=-24.0
var velocity:=Vector3.ZERO
var movement_speed:= 10
var rotation_speed:=.05
var jump_power:=7

#Onready
onready var ui:=$UI
onready var hoe_anim:=$Hoe/AnimationPlayer

#Prefabs
var tilled_prefab=preload("res://Scenes/Plant.tscn")


#The items...
onready var hoe:=$Hoe

#Interaction with plots
export(Resource) var current_plant


func _ready():
	ui.items.append(hoe)
	current_plant=null


func _physics_process(delta):
	var vy = velocity.y
	get_input()
	
	velocity.y = vy + gravity * delta
	
	velocity = move_and_slide(velocity, Vector3.UP)
	
	if jumping and is_on_floor():
		velocity.y = jump_power
	

func get_input():
	velocity = Vector3.ZERO
	
	var z = Input.get_action_strength("s") - Input.get_action_strength("w")
	velocity+=z*movement_speed *transform.basis.z
	
	var x = Input.get_action_strength("d") - Input.get_action_strength("a")
	velocity+=x*movement_speed *transform.basis.x

	jumping = Input.is_action_pressed("ui_select")
	
	var rot_y=Input.get_action_strength("q") - Input.get_action_strength("e")
	
	rotate_y(rot_y*rotation_speed)
	
	if Input.is_action_just_pressed("right_click"):
		match ui.equipped:
			"Hoe":
				hoe_anim.play("Swing")
				if on_farm and !jumping:
					var plant=tilled_prefab.instance()
					plant.global_transform=global_transform
					plant.translation.y-=.75
					plant.translation.z-=.5
					get_parent().add_child(plant)
					
			"Can":
				if on_farm and ui.can_capacity!=0 and current_plant!=null:
					ui.fill_can(ui.can_capacity-20)
					current_plant.get_watered()
					
			"Seed1":
				if on_farm and current_plant!=null and seeds_cnt[0]!=0:
					pass #Plant seed! 
			_:
				print("Not ready")
			

func apply_force(dir:Vector3):
	velocity+=dir


#func _unhandled_input(event):
#	if event is InputEventMouseButton:
#		rotate_y(-lerp(0, rotation_speed, event.relative.x))


func open_menu(menu_name:String):
	match menu_name:
		"Water":
			ui.ctrl_water.toggle_show(1)
			ui.ctrl_shop.hide()
			
		"Shop":
			ui.ctrl_shop.show()
			ui.ctrl_water.toggle_show(0)
			
		_:
			print("Error")	
	ui.closebtn.show()



func _on_Btn_Seed1_pressed():
	buy_seed(0)

func _on_Btn_Seed2_pressed():
	buy_seed(1)

func _on_Btn_Seed3_pressed():
	buy_seed(2)

func buy_seed(index:int):
	if ui.money-ui.seedsprices[index]<0:
		return
	seeds_cnt[index]+=1
	ui.add_money(-ui.seedsprices[index])
	ui.slots.get_child(2+index).get_child(0).text=str(seeds_cnt[index]) + "x"
