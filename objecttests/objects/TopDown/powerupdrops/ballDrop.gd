extends Sprite2D
class_name TDdroppedBall

var gravity=128
var velocity=Vector2.ZERO
var hitcount=0
var maxHits=5
var size=32
var damage=10
var lifetime=0
var have_hit=[]
func _ready():
	texture=load("res://icon.png")

func _physics_process(delta):
	lifetime+=delta
	velocity.y+=gravity*delta
	position+=velocity*delta
	rotation+=delta*PI*2
	check_collisions()
	if lifetime>=10.||hitcount>=maxHits:queue_free()



func check_collisions():
	var overlap=TDglobal.get_overlapping_objects_round(self,size)
	for object in overlap:
		if have_hit.has(object)||object==TDglobal.player:continue
		object.hurt(damage)
		hitcount+=1
		have_hit.append(object)
