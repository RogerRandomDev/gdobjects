extends Sprite2D
class_name TDEntity2D
#exported default vaulues
@export var moveSpeed=128
@export var maxHealth=1
@export var attackPower=5
@export var size:Vector2=Vector2(64,64)
#other values
var Health=100
var invuln=0
var knockBack=0.0
var knockBackDir=0.0
#builds entity
func _ready():
	Health=maxHealth
	TDglobal.add_object(self)
	texture=load("res://icon.png")

func _physics_process(delta):
	if(invuln>0):
		self_modulate=Color(100,0,0)
		invuln-=delta
	else:
		self_modulate=Color.WHITE
	if TDglobal.player!=self:
		var move_dir=(TDglobal.player.global_position-global_position)
		if move_dir.length_squared()>4096:position+=move_dir.normalized()*delta*moveSpeed
	if knockBack:
		knockBack=max(knockBack-delta,0)
		position+=knockBackDir*knockBack*delta

func attack(object):
	if(object.invuln<=0):object.hurt(attackPower)
func hurt(power):
	TDglobal.popDamage(str(min(power,Health)),global_position)
	Health=max(Health-power,0)
	if Health<=0:die()
#dies and decides whether or not to drop exp orb
func die():
	var drop_item=randi_range(0,5)<1*TDglobal.luck
	
	prep_free()


func prep_free():
	TDglobal.remove_object(self)
	queue_free()


#knockback function
func knockBackFrom(from,force):
	var dir=(global_position-from).normalized()
	knockBackDir=dir*force
	knockBack=1

