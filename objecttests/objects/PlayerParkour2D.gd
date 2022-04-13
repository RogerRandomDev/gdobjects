extends LivingObject2D
class_name PlayerParkour2D
#lotsa variables for this bastard
@export var jumpForce:int=128

@export var moveSpeed:int=128
@export var accelRate:float=2.5
@export var decelRate:float=1.5

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
#this one just helps to check which direction you last went in
var lastdir=Vector2.ZERO

@export var jumpForgivenessTime:float=0.125

func _ready():
	GlobalHelper.player=self
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
	super._physics_process(delta)
	var movedir=getInputMotion()
	#deals with the check for if on floor
	if is_on_floor():
		cur_jump_count=-1
		wallJumped=false
		canJump=true
		totalCling=0.0
		movedir.x*=friction
		#this stops the timer for extra jump time after leaving edge
		if get_node("jumpForgivenessTimer").time_left!=0:get_node("jumpForgivenessTimer").stop()
	else:
		#this starts the timer for extra jump time after leaving edge
		if canJump&&get_node("jumpForgivenessTimer").time_left==0:get_node("jumpForgivenessTimer").start()
	if abs(velocity.x)>=16:lastdir.x=velocity.x
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
			var vell=velocity.y
			velocity= wallJumpForce*Vector2(wall_jump.x,-1)
			velocity.y=velocity.y+min(vell,0.)
			wallJumped=true
	#wall clinging
	if Input.is_action_just_pressed("shift")&&wallCling&&get_wall_normals()!=Vector2.ZERO:
		doCling=true
	if Input.is_action_just_released("shift"):
		doCling=false
	#allows cling but total cling since on floor is capped
	if(doCling)&&totalCling<=wallClingDuration:
		totalCling+=delta
		velocity=Vector2.ZERO

#returns normal values for the wall slide collision
func get_wall_normals():
	var storedvel=velocity;var lpos=position
	velocity.x=lastdir.x
	move_and_slide()
	var count: = get_slide_collision_count()
	velocity=storedvel;position=lpos
	if count != 0:
		for slide in count:
			var norm= get_slide_collision( slide ).get_normal()
			if norm.x!=0:
				return norm
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



#used to reset cling and jumps if its upward
func bounceOff(side=Vector2.ZERO,force:float=0.0):
	super.bounceOff(side,force)
	if side.y==-1:
		totalCling=0.
		canJump=true
		cur_jump_count=-1
