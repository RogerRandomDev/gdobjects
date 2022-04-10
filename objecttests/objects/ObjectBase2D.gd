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
