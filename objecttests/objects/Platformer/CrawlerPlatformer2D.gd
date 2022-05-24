extends PLLivingObject2D
class_name CrawlerPlatformer2D
var shape = PhysicsPointQueryParameters2D.new()
@export var size:Vector2=Vector2.ZERO
@export var speed:int=128
@export var direction:Vector2=Vector2(1,0)
@export var delay_at_end:float=0.0
@export var checkFloor:bool=true
@export var checkWalls:bool=true
@export var wantFloor:bool=true
@export var wantWalls:bool=true
@export var wallCount:int=0
@export var fireProjectiles:bool=false
var can_move=true
func _ready():
	shape.collision_mask=2
	shape.position=global_position+size/2
	if delay_at_end!=0.:
		var delay_timer=Timer.new()
		delay_timer.wait_time=delay_at_end
		delay_timer.connect("timeout",move_again)
		delay_timer.name="delay"
		add_child(delay_timer)
	if fireProjectiles:
		var launcher=PLProjectileLauncher2D.new()
		add_child(launcher)
	

func _physics_process(delta):
	if !can_move:return
	super._physics_process(delta)
	var check=0
	var walls=0
	if checkFloor:check+=checkfloor()
	if checkWalls:walls+=checkwalls()
	
	if checkFloor&&(check<2||(walls!=0&&direction.y==0)):
		direction.x*=-1
		can_move=false
		do_delay()
	if walls<2&&direction.y!=0:
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
	if wantFloor:return check.size()
	else:return 2-check.size()
func checkwalls():
	shape.position=global_position-size/2+Vector2.ONE
	shape.position.x-=1
	var check:=get_world_2d().direct_space_state.intersect_point(shape)
	shape.position.y+=size.y-2
	check+=get_world_2d().direct_space_state.intersect_point(shape)
	shape.position.x+=size.x+2
	check+=get_world_2d().direct_space_state.intersect_point(shape)
	shape.position.y-=size.y-2
	check+=get_world_2d().direct_space_state.intersect_point(shape)
	#used to make sure if you wanted walls or not
	if wantWalls:return check.size()
	else:return wallCount-check.size()



func move_again():can_move=true
func do_delay():
	if delay_at_end!=0.:
		get_node("delay").start()
	else:move_again()
