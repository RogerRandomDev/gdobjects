extends CharacterBody2D
class_name PlayerParkour2D

#lotsa variables for this bastard
@export var Gravity:int=160
@export var jumpForce:int=128

@export var moveSpeed:int=128
@export var accelRate:float=2.5
@export var decelRate:float=1.5
@export var friction:float=5.0
@export var maxJumps:int=1
@export var wallJump:bool=false
@export var wallJumpForce:Vector2=Vector2(256,128)
@export var wallCling:bool=false
@export var wallClingDuration:float=0.5
enum statelist{Empty,Base}
@export var current_state=statelist
var wallJumped=false
var cur_jump_count=0
var canJump=true

var doCling=false
var totalCling=0.0
@export var jumpForgivenessTime:float=0.125
func _ready():
	makeTimer("jumpForgivenessTimer",jumpForgivenessTime,nojumps)
func makeTimer(namee,duration,fn):
	var t=Timer.new()
	t.name=namee
	t.wait_time=duration
	t.one_shot=true
	add_child(t)
	t.connect("timeout",fn)

func _physics_process(delta):
	var state=statelist.keys()[current_state]
	if has_method(state):
		call(state,delta)
	move_and_slide()
func Base(delta):
	var movedir=getInputMotion()
	#deals with the check for if on floor
	if is_on_floor():
		velocity.y=0
		cur_jump_count=-1
		wallJumped=false
		canJump=true
		totalCling=0.0
		#this stops the timer for extra jump time after leaving edge
		if get_node("jumpForgivenessTimer").time_left!=0:get_node("jumpForgivenessTimer").stop()
	else:
		#this starts the timer for extra jump time after leaving edge
		if canJump&&get_node("jumpForgivenessTimer").time_left==0:get_node("jumpForgivenessTimer").start()
		velocity.y+=Gravity*delta
	
	#sets wallJumped to false when the movement direction is the same as current direction
	##can be used to climb walls, but that would be pretty neat as a feature
	#allows you to have more air control again
	if(wallJumped&&sign(velocity.x)==movedir.x):
		wallJumped=false
		
	#movement code for sideways
	if movedir.x!=0:
		if(sign(velocity.x)!=movedir.x)&&!wallJumped:
			velocity.x-=velocity.x*delta*decelRate*friction
			velocity.x+=movedir.x*delta*(accelRate+decelRate)*moveSpeed
		else:
			velocity.x+=movedir.x*delta*accelRate*moveSpeed
	else:
		if canJump:
			velocity.x-=velocity.x*delta*decelRate*friction
		velocity.x-=velocity.x*delta*decelRate
	#jumping
	if(movedir.y!=0):
		var wall_jump=get_wall_normals()
		#default jump, then wall jump check
		if(canJump||(cur_jump_count<maxJumps&&(wall_jump.x==0||!wallJump))):
			cur_jump_count+=1
			velocity.y=max(velocity.y-jumpForce,-jumpForce)
			wallJumped=false
			canJump=false
		elif(wall_jump.x!=0&&wallJump):
			velocity= wallJumpForce*Vector2(wall_jump.x,-1)
			wallJumped=true
	#wall clinging
	if Input.is_action_just_pressed("shift")&&is_on_wall():
		doCling=true
	if Input.is_action_just_released("shift"):
		doCling=false
	#allows cling but total cling since on floor is capped
	if(doCling)&&totalCling<=wallClingDuration:
		totalCling+=delta
		velocity=Vector2.ZERO

#returns normal values for the wall slide collision
func get_wall_normals():
	var count: = get_slide_collision_count()
	if count != 0:
		for slide in count:
			var norm= get_slide_collision( slide ).get_normal()
			if norm.x!=0:
				return norm
				break
	return Vector2.ZERO

#disables jump after the forgiveness time is up
func nojumps():
	canJump=false
#disables wall cling after time is up
func nocling():
	doCling=false
#inputs as a vector2
func getInputMotion():
	return Vector2(int(Input.is_action_pressed("r"))-int(Input.is_action_pressed("l")),int(Input.is_action_just_pressed("jump")))