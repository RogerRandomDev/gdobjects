@tool
extends Node2D
class_name areaCheck2D


var space = PhysicsShapeQueryParameters2D.new()
@export var size:Vector2=Vector2.ZERO



#defaults the value to a dictionary for me
#very convenient
@export var action:Array:
	set(value):
		for values in value.size():
			if value[values]==null:
				value[values]={
					"ActionName":"Name",
					"Values":[],
					"Repeat":false
					}
		action=value
		
	get:return action

var player_just_entered=false

func _ready():
	#sets up the check area
	space.collision_mask=1
	space.transform=transform
	space.shape=RectangleShape2D.new()
	space.shape.extents=size

func _physics_process(delta):
	if is_player_inside()&&!player_just_entered:activate_actions()
	else:player_just_entered=false

#checks for if the player collider is inside its area
func is_player_inside():
	var check:=get_world_2d().direct_space_state.intersect_shape(space)
	if check:for obj in check:if(obj.collider.is_in_group("player")):return true
	return false


#triggers the actions inside the array
func activate_actions():
	pass
