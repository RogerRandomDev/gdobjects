@tool
extends Node2D
class_name bouncePad2D
signal bounced
@export var active:bool=true
@export var checkSize:Vector2=Vector2(32,32)
@export var force:float=32
@export var left:bool=true
@export var right:bool=true
@export var up:bool=true
@export var down:bool=true
var bcheck=PhysicsShapeQueryParameters2D.new()
func _ready():
	if Engine.is_editor_hint():return
	var shape = RectangleShape2D.new()
	shape.extents=checkSize/2
	bcheck.shape=shape
	bcheck.collision_mask=2
	bcheck.transform=transform
	bcheck.transform.origin+=checkSize/2
	addCollision()
var drawline=Vector2.ZERO
func _draw():
	if !Engine.is_editor_hint():return
	draw_rect(Rect2(Vector2.ZERO,checkSize),Color(0.5,0.5,0.75,0.5))
func _process(delta):
	update()
func _physics_process(_delta):
	
	if Engine.is_editor_hint():return
	var check:=get_world_2d().direct_space_state.intersect_shape(bcheck)
	if check:
		for obj in check:
			var this=obj.collider
			if !this.has_method("bounceOff"):continue
			var bangle = getLargestNormal((this.global_position-global_position-checkSize/2).normalized())
			bangle=checkIfCan(bangle)
			this.bounceOff(-bangle,force)
			drawline=bangle*64
			
		emit_signal("bounced")


#returns the largest normal value
func getLargestNormal(normal):
	if(abs(normal.x)>abs(normal.y)):
		return Vector2(1*sign(normal.x),0)
	else:
		return Vector2(0,1*sign(normal.y))
#makes sure the side is allowed
func checkIfCan(angle):
	match(angle.x):
		-1.:
			if !left:angle.x=0
		1.:
			if !right:angle.x=0

	match(angle.y):
		-1.:
			if !up:angle.y=0
		1.:
			if !down:angle.y=0
	return angle


#builds its collision
func addCollision():
	var c=StaticBody2D.new()
	var col=CollisionShape2D.new()
	col.shape=RectangleShape2D.new()
	col.shape.extents=checkSize/2-Vector2(1,1)
	c.add_child(col)
	add_child(c)
	c.position+=checkSize/2
