extends LivingObject2D
class_name CrawlerPlatformer2D
var shape = PhysicsPointQueryParameters2D.new()
@export var size:Vector2=Vector2.ZERO
@export var speed:int=128
@export var direction:Vector2=Vector2(1,0)
@export var delay_at_end:float=0.0
@export var checkFloor:bool=true
@export var checkWalls:bool=true
@export var fireProjectiles:bool=false
var can_move=true
func _ready():
	
	shape.position=global_position+size/2
	if delay_at_end!=0.:
		var delay_timer=Timer.new()
		delay_timer.wait_time=delay_at_end
		delay_timer.connect("timeout",move_again)
		delay_timer.name="delay"
		add_child(delay_timer)
	if fireProjectiles:
		var launcher=ProjectileLauncher2D.new()
		add_child(launcher)
	

func _physics_process(delta):
	if !can_move:return
	super._physics_process(delta)
	var check=[]
	var walls=[]
	if checkFloor:check+=checkfloor()
	if checkWalls:walls+=checkwalls()
	if checkFloor&&(check.size()<2||(walls.size()!=0&&direction.y==0)):
		direction.x*=-1
		can_move=false
		do_delay()
	if walls.size()<2&&direction.y!=0:
		direction.y*=-1
		can_move=false
		do_delay()
	velocity=direction*speed
	move_and_slide()


func checkfloor():
	shape.position=global_position+size/2
	var check:=get_world_2d().direct_space_state.intersect_point(shape)
	shape.position.x-=size.x
	check+=get_world_2d().direct_space_state.intersect_point(shape)
	return check
func checkwalls():
	shape.position=global_position-size/2+Vector2.ONE
	shape.position.x-=1
	var check:=get_world_2d().direct_space_state.intersect_point(shape)
	shape.position.y+=size.y-1
	check+=get_world_2d().direct_space_state.intersect_point(shape)
	shape.position.x+=size.x+2
	check+=get_world_2d().direct_space_state.intersect_point(shape)
	shape.position.y-=size.y-1
	check+=get_world_2d().direct_space_state.intersect_point(shape)
	return check

func move_again():can_move=true
func do_delay():
	if delay_at_end!=0.:
		get_node("delay").start()
	else:move_again()
