extends Sprite2D
class_name TDprojectile

var direction=Vector2.ZERO
var damage=5
var size=Vector2(16,16)
func _ready():
	texture=load("res://icon.png")
	scale*=0.25

func _physics_process(delta):
	position+=direction*delta
	var col=TDglobal.get_overlapping_objects_box(self,size)
	if col:
		if col.size()==1&&col[0]==TDglobal.player:return
		for coll in col:
			if coll==TDglobal.player:continue
			coll.hurt(damage)
		queue_free()
