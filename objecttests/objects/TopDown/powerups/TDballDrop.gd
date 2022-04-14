extends TDPowerUpBase2D
class_name TDballDrop

var dropCount=3
func _ready():
	atkSpeed=5
	super._ready()


func _physics_process(delta):
	super._physics_process(delta)
	if curTime<=atkSpeed:return
	curTime-=atkSpeed
	var tween:Tween=create_tween()
	for dropped in dropCount:
		tween.tween_callback(makedrop)
		tween.tween_interval(0.25)
func makedrop():
	var dir=Vector2(
		randi_range(-96,96),
		randi_range(-160,-96)
	)
	var drop=TDdroppedBall.new()
	p.get_parent().add_child(drop)
	drop.velocity=dir+p.get_inputs()*p.moveSpeed
	drop.global_position=p.global_position
