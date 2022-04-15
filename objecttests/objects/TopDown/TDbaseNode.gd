extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	var n=Node2D.new()
	GlobalHelper.ProjectileHolder=n
	add_child(n)
	TDglobal.textPop=$textpop/Control
	TDglobal.camera=$TDPlayer2D/Camera2D
	TDglobal.root=self
	randomize()

var time=0
#adds enemies
func physics_process(delta):
	time+=delta
	var wait_time=randf_range(1,5)
	if time>=wait_time:
		time-=wait_time
		var enem_count=randi_range(1,5)
		for enemy in enem_count:
			var enem=TDEntity2D.new()
			position_enemy(enem)
		if randi_range(0,10)>0:
			for i in randi_range(10,40):
				var h=TDEntity2D.new()
				position_enemy(h)
func position_enemy(e):
	add_child(e)
	var center=TDglobal.player.global_position
	var side=randi_range(0,3)
	e.global_position=center
	match side:
		0:
			e.global_position.y=center.y-364
			e.global_position.x+=randi_range(-576,576)
		1:
			e.global_position.y=center.y+364
			e.global_position.x+=randi_range(-576,576)
		2:
			e.global_position.x=center.x-576
			e.global_position.y+=randi_range(-364,364)
		3:
			e.global_position.x=center.x+576
			e.global_position.y+=randi_range(-364,364)
	
