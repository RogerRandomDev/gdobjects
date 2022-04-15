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
var is_player=false

func changed():return
#builds entity
func _ready():
	disable_process()
	Health=maxHealth
	TDglobal.add_object(self)
	texture=load("res://icon.png")
func disable_process():
	set_physics_process(false)
	set_process(false)
	set_process_internal(false)
	set_physics_process_internal(false)
func enable_process():
	set_physics_process(true)
	set_process(true)
	set_process_internal(true)
	set_physics_process_internal(true)

var lloop=0
var push_force=Vector2.ZERO
var nearby=[]
func physics_process(delta):
	
	if knockBack:
		knockBack=max(knockBack-delta,0)
		position+=knockBackDir*knockBack*delta
	if is_player||!is_inside_tree():return
	var move_dir=(TDglobal.player.global_position-global_position)
	if move_dir.length_squared()<4096:return
	position+=(move_dir.normalized()*moveSpeed+push_force)*delta
	if lloop%15==0:
		push_force=Vector2.ZERO
		for object in nearby:
			if !object.is_inside_tree():continue
			var e=(object.global_position-global_position)
			if e.length_squared()>4096:continue
			push_force-=e.normalized()*(4096-e.length_squared())/32
		push_force.x=min(abs(push_force.x),128)*sign(push_force.x)
		push_force.y=min(abs(push_force.y),128)*sign(push_force.y)
		if lloop>=60:
			lloop=0;
			nearby=[]
			for enemy in TDglobal.objects:
				if !enemy.is_inside_tree():continue
				if(enemy.global_position-global_position).length_squared()<65536:
					nearby.append(enemy)
	lloop+=1
func attack(object):
	if(object.invuln<=0):object.hurt(attackPower)
func hurt(power):
	TDglobal.popDamage(str(min(power,Health)),global_position)
	Health=max(Health-power,0)
	if Health<=0:die()
#dies and decides whether or not to drop exp orb
func die():
	var drop_item=randi_range(0,5)<1*TDglobal.luck
	if drop_item:
		var n=TDPickUp2D.new()
		n.global_position=global_position
		TDglobal.root.add_child(n)
	call_deferred('prep_free')


func prep_free():
	TDglobal.remove_object(self)
	call_deferred('queue_free')


#knockback function
func knockBackFrom(from,force):
	var dir=(global_position-from).normalized()
	knockBackDir=dir*force
	knockBack=1

