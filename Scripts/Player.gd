extends KinematicBody

export var movement_speed:= 10
export var rotation_speed:=.01
export var jump_power:=7
export(bool) var on_farm=false

var jumping:=false

var gravity:=-24.0
var velocity:=Vector3.ZERO

onready var ui:=$UI
onready var hoe_anim:=$Hoe/AnimationPlayer

#The items...
onready var hoe:=$Hoe


func _ready():
	ui.items.append(hoe)


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
	
	if Input.is_action_just_pressed("click"):
		match ui.equipped:
			"Hoe":
				hoe_anim.play("Swing")
				if on_farm:
					pass #Instance place to plant
			"Can":
				if on_farm:
					ui.can_capacity-=20
			_:
				print("Not ready")
			
func _unhandled_input(event):
	if event is InputEventMouseMotion:
		rotate_y(-lerp(0, rotation_speed, event.relative.x))

func apply_force(dir:Vector3):
	velocity+=dir

func start_fill():
	ui.get_child(1).show()
	ui.get_child(1).showing=true
	
