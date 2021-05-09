extends Area

#Every plant needs fertilizer and water
# and time for its growth

export(int) var water=0 #0-100. Use soil mesh overlay opacity to show thirst
export(int) var nutrients=0 #0-100. Same as above but for plant stem.
export(int) var seeds=0 #1-3 for each type of plant. 0 when no seed.

#Timers
onready var grow_timer:=$GrowthTimer
onready var thirst_timer:=$WaterTimer

#Mesh
onready var soil:=$Soil
var soil_mat=preload("res://Assets/Soil.tres")
#Default color is rgba 108 67 37 255

#TEST
onready var mi:=$Soil/MeshInstance



func _ready():
	change_soil_color()
	thirst_timer.start()

	
func start_growth(seed_type:int):
	seeds=seed_type
	grow_timer.start()

func _on_WaterTimer_timeout():
	if water!=0:
		water-=.1
	change_soil_color()
	thirst_timer.start()
	if water!=.5:
		grow_timer.stop()

func change_soil_color(): 
	 #25 66 42 255
	#Color(0.42,0.26,0.14, 1)
	print("Chnging color!")
	soil_mat.albedo_color=Color.from_hsv(.069, .66, 1-water, 1)
	for i in soil.get_children():
		i.material_override=soil_mat


func get_watered():
	water=.5
	change_soil_color()


func _on_Area_body_entered(body):
	if "Player" in body.name:
		if body.current_plant==null:
			body.current_plant=self
		


func _on_Area_body_exited(body):
	if "Player" in body.name:
		if body.current_plant==self:
			body.current_plant=null
