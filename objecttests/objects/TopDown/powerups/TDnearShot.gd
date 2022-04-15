extends TDPowerUpBase2D
class_name TDnearShot

var dropCount=5

func _ready():
	super._ready()
	atkSpeed=2
func _physics_process(delta):
	super._physics_process(delta)
	if(curTime<atkSpeed):return
	curTime-=atkSpeed
	attack_action()


var shootAt=null
func attack_action():
	var overlaps=TDglobal.get_overlapping_objects_round(p,1024)
	if overlaps:
		
		shootAt=get_closest(overlaps)[0]
		var tween:Tween=create_tween()
		
		for dropped in dropCount:
			tween.tween_callback(makeDrop)
			tween.tween_interval(0.25)

func makeDrop():
	if !is_instance_valid(shootAt)||!shootAt.is_inside_tree():shootAt=get_closest(TDglobal.get_overlapping_objects_round(p,1024))[0]
	if shootAt==null:return
	var shot=TDprojectile.new()
	GlobalHelper.ProjectileHolder.add_child(shot)
	shot.global_position=p.global_position
	shot.direction= -((p.global_position-shootAt.global_position).normalized()*512).rotated(randf_range(-PI/32,PI/32))

func get_closest(overlaps):
	var gpos=p.global_position
	var closest=[null,100000000000]
	for object in overlaps:
		var lll=(object.global_position-gpos).length_squared()
		if lll<closest[1]:closest=[object,lll]
	return closest
