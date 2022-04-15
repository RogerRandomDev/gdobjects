extends TDEntity2D
class_name TDPickUp2D

var move_to=null
var progress=-0.5
var expVal=1
func _ready():
	super._ready()
	TDglobal.remove_object(self)
	TDglobal.add_pickup(self)
func physics_process(delta):
	if move_to==null||!is_inside_tree():return
	progress+=delta
	var dist=(move_to.global_position-global_position)
	var move_by=dist*delta*5*progress
	position.x+=min(abs(move_by.x),512*delta)*sign(move_by.x)
	position.y+=min(abs(move_by.y),512*delta)*sign(move_by.y)
	var s=dist.length_squared()
	#start shrinking for pickup
	if s<4096:
		var e=s/4096
		scale*=e
		if scale.x<0.1&&!is_queued_for_deletion():
			move_to.gainExp(expVal)
			call_deferred('prep_free')

func pickup(obj):move_to=obj



func prep_free():
	TDglobal.remove_pickup(self)
	call_deferred('queue_free')
