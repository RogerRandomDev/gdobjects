extends TDPowerUpBase2D
class_name TDsidewaySwipe
var attacksprite=Sprite2D.new()

func _ready():
	atkSpeed=1
	attacksprite.texture=load("res://icon.png")
	add_child(attacksprite)
	attacksprite.visible=false
	attacksprite.centered=false
	super._ready()


func _physics_process(delta):
	super._physics_process(delta)
	attacksprite.global_position=p.global_position-Vector2(0,48)
	if curTime<atkSpeed:return
	curTime-=atkSpeed
	var tween:Tween=create_tween()
	
	tween.tween_callback(hitside)
	tween.tween_callback(attacksprite.show)
	tween.tween_property(attacksprite,"modulate",Color(1,1,1,1),0.125)
	tween.tween_property(attacksprite,"modulate",Color(1,1,1,0),0.25)
	tween.tween_callback(attacksprite.hide)

func hitside(side=1.):
	side*=p.facing.x
	attacksprite.scale.x=atkRange/64 * side
	var overlap=TDglobal.get_overlapping_objects_box(get_parent(),Vector2(256,64),Vector2(256*min(max(side,-1),0),-48))
	var pos=get_parent().global_position
	for object in overlap:
		object.hurt(atkPower)
		object.knockBackFrom(pos,knockbackForce)
