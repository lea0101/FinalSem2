extends Area

#Every plant needs fertilizer and water
# and time for its growth

export(int) var water=0 #0-100. Use soil mesh overlay opacity to show thirst
export(int) var nutrients=0 #0-100. Same as above but for plant stem.
export(int) var seeds=0 #1-3 for each type of plant. 0 when no seed.

export(int) var grow_stage=0

#Timers
onready var grow_timer:=$GrowthTimer
onready var thirst_timer:=$WaterTimer

#Mesh
onready var soil:=$Soil
var soil_mat=preload("res://Assets/Soil.tres")
#Default color is rgba 108 67 37 255

var seed1_prefab=preload("res://Scenes/Seed.glb")
var stage1_prefab=preload("res://Assets/Plants/Plant1.glb")
var stage2_prefab=preload("res://Assets/Plants/Plant1_Stage2.glb")


#Plant 1
var plant1_final_prefab=preload("res://Assets/Plants/Plant1_Final.glb")

#Plant 2
var plant2_final_prefab=preload("res://Assets/Plants/Plant2/Plant2.glb")

#Plant 3
var plant3_final_prefab=preload("res://Assets/Plants/Plant3/Plant3.glb")

onready var stage_parent:=$Current_Stage


func _ready():
	change_soil_color()
	thirst_timer.start()

	
func start_growth(seed_type:int):
	seeds=seed_type+1
	grow_timer.start()

	var s = seed1_prefab.instance()
	stage_parent.add_child(s)
	s.global_transform=global_transform
	s.global_translate(Vector3(-.01, .33, -.025))


func _on_WaterTimer_timeout():
	if water!=0:
		water-=.1
	change_soil_color()
	thirst_timer.start()
	if water<.3:
		print("Stopping growth!")
		grow_timer.wait_time=grow_timer.time_left
		grow_timer.stop()



func change_soil_color(): 
	 #25 66 42 255
	#Color(0.42,0.26,0.14, 1)
	print("Changing color!")
	soil_mat.albedo_color=Color.from_hsv(.069, .66, 1-water, 1)
	for i in soil.get_children():
		i.material_override=soil_mat


func get_watered():
	water=.5
	change_soil_color()
	if grow_timer.is_stopped():
		grow_timer.start()
		print("Starting growth")


func _on_Area_body_entered(body):
	if "Player" in body.name:
		if body.current_plant==null:
			body.current_plant=self
		

func _on_Area_body_exited(body):
	if "Player" in body.name:
		if body.current_plant==self:
			body.current_plant=null


func _on_GrowthTimer_timeout():
	grow_stage+=1
	match grow_stage:
			1:
				inst_plant(stage1_prefab, Vector3(0,1,0))
		
			2:
				inst_plant(stage2_prefab, Vector3(0,1.4,0))
					
			3:
				match seeds:
					1:
						inst_plant(plant1_final_prefab, Vector3(0,1.4,0))
					2:
						inst_plant(plant2_final_prefab, Vector3(0,1.4,0))
					3:
						inst_plant(plant3_final_prefab, Vector3(0,1.4,0))
						
				thirst_timer.stop()
				grow_timer.stop()	

		
func inst_plant(prefab,trans):
	if(stage_parent.get_child(0)!=null):
		stage_parent.get_child(0).queue_free()
		var p = prefab.instance()
		p.global_transform=global_transform
		p.translate(trans)
		stage_parent.add_child(p)
		grow_timer.start()
