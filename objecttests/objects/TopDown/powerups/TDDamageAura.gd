extends TDPowerUpBase2D
class_name TDDamageAura

func _ready():
	super._ready()
	atkSpeed=0.5
	atkRange=256


func _physics_process(delta):
	super._physics_process(delta)
	if curTime<=atkSpeed:return
	curTime-=atkSpeed
	doCollision()


func doCollision():
	var overlap=TDglobal.get_overlapping_objects_round(p,atkRange)
	for object in overlap:
		object.hurt(atkPower)
