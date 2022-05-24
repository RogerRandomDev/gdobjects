@tool
extends Node2D
class_name PLbouncePad2D
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
	call_deferred("setup")
func setup():
	var shape = RectangleShape2D.new()
	shape.extents=checkSize/2
	bcheck.shape=shape
	bcheck.transform=global_transform
	bcheck.collision_mask=1
	
	addCollision()


func _physics_process(_delta):
	if Engine.is_editor_hint():return
	
	var check:=get_world_2d().direct_space_state.intersect_shape(bcheck)
	if check:
		for obj in check:
			var this=obj.collider
			
			if !this.has_method("bounceOff"):continue
			this.bounceOffFull(global_position,force,[left,right,up,down])
			
		emit_signal("bounced")


#builds its collision
func addCollision():
	var c=StaticBody2D.new()
	var col=CollisionShape2D.new()
	col.shape=RectangleShape2D.new()
	col.shape.extents=checkSize/2-Vector2(1,1)
	c.add_child(col)
	add_child(c)
