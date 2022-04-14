extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	TDglobal.root=self
	GlobalHelper.ProjectileHolder=$projectileholder
	TDglobal.textPop=$textpop/Control
	TDglobal.camera=$TDPlayer2D/Camera2D
	randomize()

var time=0
var wait_time=0
#adds enemies
func physics_process(delta):
	if !is_inside_tree():return
	time+=delta
	
	if time>=wait_time:
		
		time-=wait_time
		wait_time=randf_range(5,10)
		var enem_count=randi_range(5,15)
		for enemy in enem_count:
			var enem=TDEntity2D.new()
			var side=randi_range(0,3)
			position_enemy(enem,side)
		var horde_action=randi_range(0,100)
		if horde_action<100:
			var side=randi_range(0,3)
			for enemy in 240:
				var enem=TDEntity2D.new()
				call_deferred('position_enemy',enem,side,randf_range(0.,1.2))
func position_enemy(e,side,offset=0.):
	add_child(e)
	var center=TDglobal.player.global_position
	e.global_position=center
	match side:
		0:
			e.global_position.y=center.y-364.-randf_range(0,256*offset)
			e.global_position.x+=randf_range(-576.,576.)*offset
		1:
			e.global_position.y=center.y+364.+randf_range(0,256*offset)
			e.global_position.x+=randf_range(-576.,576.)*offset
		2:
			e.global_position.x=center.x-576.-randf_range(0,256*offset)
			e.global_position.y+=randf_range(-364,364)*offset
		3:
			e.global_position.x=center.x+576.+randf_range(0,256*offset)
			e.global_position.y+=randf_range(-364,364)*offset
	
