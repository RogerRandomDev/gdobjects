extends Sprite2D
class_name Projectile2D
const max_life=15
var my_life=0.0
var direction=Vector2.ZERO
var shape=PhysicsShapeQueryParameters2D.new()
func _ready():
	var ex=RectangleShape2D.new()
	ex.extents=Vector2(4,4)
	shape.shape=ex
	scale=Vector2(0.25,0.25)
	shape.collision_mask=3
	texture=load("res://icon.png")

func _physics_process(delta):
	my_life+=delta
	if max_life<=my_life:queue_free()
	position+=direction*delta
	check_collisions()


func check_collisions():
	shape.transform=transform
	
	var check:=get_world_2d().direct_space_state.intersect_shape(shape)
	if check:
		queue_free()
