extends Sprite2D
class_name Platform2D

@export var moving:bool=true
@export var moveDirection:Vector2=Vector2(128,0)
@export var moveDistance:int=256
@export var wait_at_end:float=0.0
@export var bouncy:bool=true
@export var force:int=256
@export var left:bool=true
@export var right:bool=true
@export var up:bool=true
@export var down:bool=true
var my_collision=null
var travelled=0.0
var shape=PhysicsShapeQueryParameters2D.new()

func _ready():
	if wait_at_end!=0.0:
		var t=Timer.new()
		t.wait_time=wait_at_end
		add_child(t)
		t.name="waittime"
		t.connect('timeout',canmoveagain)
	my_collision=build_collision()
	my_collision.constant_linear_velocity=moveDirection

func _physics_process(delta):
	if bouncy:checkBounce()
	if !moving:return
	travelled+=abs(moveDirection*delta).length()
	position+=moveDirection*delta
	if travelled>=moveDistance:
		position-=((moveDistance-travelled)*moveDirection.normalized())
		travelled=0.;moveDirection*=-1
		my_collision.constant_linear_velocity=Vector2.ZERO
		do_at_end()


func canmoveagain():
	my_collision.constant_linear_velocity=moveDirection
	moving=true
func do_at_end():
	moving=false
	if wait_at_end!=0.0:get_node("waittime").start()
	else:canmoveagain()






func build_collision():
	var size=Vector2(texture.get_width(),texture.get_height())/2
	var o=RectangleShape2D.new()
	o.extents=size
	var col=CollisionShape2D.new()
	var held=StaticBody2D.new()
	held.add_child(col)
	col.shape=o
	add_child(held)
	if bouncy:
		shape.shape=RectangleShape2D.new()
		shape.shape.extents=size*scale/2
		shape.shape.extents=size+Vector2(1,1)
		modify_transform=size
		shape.collision_mask=2
	return held

var modify_transform=Vector2.ZERO

func checkBounce():
	shape.transform=transform
	shape.transform.origin
	var check:=get_world_2d().direct_space_state.intersect_shape(shape)
	if check:
		var shapes=get_world_2d().direct_space_state.collide_shape(shape)
		var average=Vector2(0,0)
		if shapes.size()!=0:
			for point in shapes:
				average+=point
			average/=shapes.size()
		for bodyy in check.size():
			var bod=check[bodyy]
			if !bod.collider.has_method("bounceOff"):continue
			bod.collider.bounceOffFull(average,force,[left,right,up,down])
	
