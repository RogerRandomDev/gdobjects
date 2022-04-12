extends Camera2D
class_name CinemaCamera2D

var starting_target=null

var shake=0.0
@export var shake_decay:float=2.5
@export var shake_strength:Vector2=Vector2(16,16)


func _ready():
	starting_target=get_parent()
	randomize()

func _process(delta):
	if shake:
		shake-=delta*shake_decay*shake
		shake=max(shake,0.)
		shake_screen()


func shake_screen():
	offset=Vector2(
		randf_range(-1.,1.),
		randf_range(-1.,1.)
		)*shake_strength*pow(shake,1.25)

func add_shake(amount:float=0.0):
	shake=min(shake+amount,1.)









func move_offset(pos:Vector2,time:float=0.0):
	var tween:Tween=create_tween()
	tween.tween_property(self,'offset',pos,time)

func reset():
	get_parent().remove_child(self)
	starting_target.add_child(self)
	offset=Vector2.ZERO
	position=Vector2.ZERO
