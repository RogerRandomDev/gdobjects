extends TDEntity2D
class_name TDPlayer2D


var expe=0
var level=1

var facing=Vector2(1,0)
func _ready():
	super._ready()
	TDglobal.setPlayer(self)
	TDglobal.remove_object(self)
func _physics_process(delta):
	super.physics_process(delta)
	var dir=get_inputs()
	
	#sets facing direction for abilities
	if dir.x!=0:facing.x=dir.x
	if dir.y!=0:facing.y=dir.y
	position+=dir*moveSpeed*delta
	var hit_enemy=TDglobal.get_overlapping_objects_box(self,Vector2(64,64),Vector2(-32,-32))
	if hit_enemy:hit_enemy[0].attack(self)
	TDglobal.pickup_overlapping_items(self,72)

func gainExp(val):
	expe+=val
func hurt(val):
	Health=max(Health-val,0)
	invuln=0.25

func get_inputs():
	return Vector2(
		int(Input.is_action_pressed("r"))-int(Input.is_action_pressed("l")),
		int(Input.is_action_pressed("down"))-int(Input.is_action_pressed("up"))
		)
