extends KinematicBody


export(bool) var on_farm=false
export(Array) var seeds_cnt=[0,0,0]
export(Array) var plants_cnt=[0,0,0]

#bools
var jumping:=false

#physics
var gravity:=-24.0
var velocity:=Vector3.ZERO
var movement_speed:= 10
var rotation_speed:=7
var jump_power:=7


#Onready
onready var ui:=$UI
onready var hoe_anim:=$Hoe/AnimationPlayer
onready var can_anim:=$Can/AnimationPlayer
onready var can_particles:=$Can/Particles

#Prefabs
var tilled_prefab=preload("res://Scenes/Plant.tscn")

#Camera
onready var scroll_x:=$Scroll_ViewX


#The items...
onready var hoe:=$Hoe
onready var can:=$Can

#Interaction with plots
export(Resource) var current_plant


func _ready():
	print("Rotation:", rotation_degrees.x)
	ui.items.append(hoe)
	ui.items.append(can)
	current_plant=null
	scroll_x.value=50


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

	rotation_degrees.x=35-scroll_x.value
	rotation_degrees.y+= rotation_speed *(Input.get_action_strength("q") - Input.get_action_strength("e"))

	if Input.is_action_just_pressed("click") and on_farm and current_plant!=null and current_plant.grow_stage>=3:
		plants_cnt[current_plant.seeds-1]+=1
		current_plant.queue_free()
		ui.ctrl_inv.update_cnt()

	if Input.is_action_just_pressed("right_click"):
		match ui.equipped:
			"Hoe":
				hoe_anim.play("Swing")
				if on_farm and !jumping:
					var plant=tilled_prefab.instance()
					plant.rotation_degrees=Vector3.ZERO
					plant.global_transform=global_transform
					plant.translation.y-=1.25
					plant.translation.z-=.5
					get_parent().add_child(plant)

			"Can":
				if on_farm and ui.can_capacity!=0 and current_plant!=null:
					ui.fill_can(ui.can_capacity-20)
					current_plant.get_watered()
					can_anim.play("pour")
					can_particles.emitting=true

			"Seed1":
				if on_farm and current_plant!=null and seeds_cnt[0]!=0:
					current_plant.start_growth(0)
					use_seed(0)
			"Seed2":
				if on_farm and current_plant!=null and seeds_cnt[1]!=0:
					current_plant.start_growth(1)
					use_seed(1)
			"Seed3":
				if on_farm and current_plant!=null and seeds_cnt[2]!=0:
					current_plant.start_growth(2)
					use_seed(2)	
			_:
				print("Not ready")


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

func use_seed(index:int):
	seeds_cnt[index]-=1
	ui.slots.get_child(2+index).get_child(0).text=str(seeds_cnt[index]) + "x"

