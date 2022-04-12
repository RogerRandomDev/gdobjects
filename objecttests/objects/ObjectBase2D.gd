extends CharacterBody2D
class_name ObjectBase2D
@export var Gravity:int=160
@export var friction:float=5.0
@export var bounce:bool=true
@export var bounceMult:float=1.0

func _physics_process(delta):
	if is_on_floor():
		velocity.y=0
		velocity.x-=velocity.x*delta*friction
	else:
		velocity.y+=Gravity*delta
#full bounce calculations done here
func bounceOffFull(pos,force:int=0,sides=[true,true,true,true]):
	var bangle = getLargestNormal((global_position-pos).normalized())
	bangle=checkIfCan(bangle,sides)
	bounceOff(-bangle,force)
#only bounces of side if it can
func checkIfCan(angle,sides):
	match(angle.x):
		-1.:
			if !sides[0]:angle.x=0
		1.:
			if !sides[1]:angle.x=0

	match(angle.y):
		-1.:
			if !sides[2]:angle.y=0
		1.:
			if !sides[3]:angle.y=0
	return angle

#returns the largest normal value
func getLargestNormal(normal):
	if(abs(normal.x)>abs(normal.y)):
		return Vector2(1*sign(normal.x),0)
	else:
		return Vector2(0,1*sign(normal.y))


func bounceOff(side=Vector2.ZERO,force:float=0.0):
	if side==Vector2.ZERO:return
	var vy=max(abs(velocity.y/320),1)
	var vx=max(abs(velocity.x/320),1)
	match side.x:
		-1.:
			velocity.x=bounceMult*force*vx
		1.:
			velocity.x= -bounceMult*force*vx
	match side.y:
		-1.:
			velocity.y= bounceMult*force*vy
		1.:
			velocity.y= -bounceMult*force*vy
	move_and_slide()
