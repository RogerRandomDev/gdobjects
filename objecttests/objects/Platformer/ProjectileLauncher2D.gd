extends Node2D
class_name PLProjectileLauncher2D

@export var fire_rate=0.25
var time_since_last=0.0
var raycheck=PhysicsRayQueryParameters2D.new()


func _physics_process(delta):
	time_since_last+=delta
	if time_since_last<fire_rate:return
	var world:=get_world_2d().direct_space_state
	loadray()
	var check:=world.intersect_ray(raycheck)
	if check.size()==0||check.collider!=GlobalHelper.player:
		time_since_last=min(time_since_last,fire_rate)
		return
	var launchdir=(raycheck.to-raycheck.from).normalized()
	fireProjectile(launchdir)
	time_since_last-=fire_rate


func loadray():
	raycheck.from=global_position
	raycheck.to=GlobalHelper.player.global_position


func fireProjectile(direction):
	var proj=PLProjectile2D.new()
	proj.direction=direction*512
	proj.global_position=global_position
	GlobalHelper.ProjectileHolder.add_child(proj)




